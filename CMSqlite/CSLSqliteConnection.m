//
//  CSLSqliteConnection
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import "CSLSqliteConnection.h"

#include <sqlite3.h>

@interface CSLSqliteConnection()
{
	sqlite3 *_db;
}
@end

@implementation CSLSqliteConnection

- (id)initWithPath:(NSString *)path
{
	NSLog(@"Opening database at %@", path);
	
	if (self = [super init]) {
		_executingAsync = NO;
		
		int res = sqlite3_open(path.UTF8String, &_db);
		
		_tableNames = [[NSMutableArray alloc] init];
		
		if (res) {
			NSLog(@"Error opening DB: %d, %s, %@", res, sqlite3_errmsg(_db), path);
		} else { // Get tables
			[self executeSQL:@"SELECT name FROM sqlite_master WHERE type='table';" processRow:^BOOL(int columnCount, char **results, char **columns) {
				for (int i = 0; i < columnCount; i++)
					[(NSMutableArray *)_tableNames addObject:[NSString stringWithUTF8String:results[i]]];
				
				return YES;
			} onError:^(NSString *error) {
				NSLog(@"Error: %@", error);
			}];
		}
	}
	
	return self;
}

- (void)dealloc
{
	sqlite3_close(_db);
}

- (void)executeSQL:(NSString *)sql processRow:(BOOL (^)(int columnCount, char **results, char **columns))processRow onError:(void (^)(NSString *error))onError
{
	char *error;
	
	_processRow = processRow;
	
	sqlite3_exec(_db, sql.UTF8String, &exec_callback, (__bridge void*)self, &error);
	
	if (error)
		onError([NSString stringWithUTF8String:error]);
}

int exec_callback(void *arg, int columnCount, char **results, char **columns)
{
	CSLSqliteConnection *inst = (__bridge CSLSqliteConnection*) arg;
	
	if (inst.processRow(columnCount, results, columns)) return 0;
	
	return 1;
}

- (CSLQueryResults *)executeSQL:(NSString *)sql
{
	CSLQueryResults *queryResults = [[CSLQueryResults alloc] init];
	
	[self executeSQL:sql processRow:^BOOL(int columnCount, char **results, char **columns) {
		if (queryResults.columnNames.count == 0) {
			for (int i = 0; i < columnCount; i++) {
				[queryResults.columnNames addObject:[NSString stringWithUTF8String:columns[i]]];
			}
		}
		
		NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:columnCount];
		[queryResults.rows addObject:row];
		
		for (int i = 0; i < columnCount; i++) {
			char *res = results[i];
			
			[row addObject:res == NULL ? @"" : [NSString stringWithUTF8String:results[i]]];
		}
		
		return YES;
	} onError:^(NSString *error) {
		[queryResults assignError:error];
	}];
	
	return queryResults;
}

- (void)executeSQLAsync:(NSString *)sql onComplete:(void (^)(CSLQueryResults *results))onComplete
{
	_executingAsync = YES;
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		CSLQueryResults *queryResults = [self executeSQL:sql];
		
		_executingAsync = NO;
		
		onComplete(queryResults);
	});
}

- (NSArray *)executeSQLGetDictionaryRows:(NSString *)sql
{
	NSMutableArray *rows = [[NSMutableArray alloc] init];
	
	[self executeSQL:sql processRow:^BOOL(int columnCount, char **results, char **columns) {
		NSDictionary *dict = [CSLSqliteConnection dictionaryFromRow:results columns:columns columnCount:columnCount];
		[rows addObject:dict];
		
		return YES;
	} onError:^(NSString *error) {
		NSLog(@"Error: %@", error);
	}];
	
	return rows	;
}

+ (NSDictionary *)dictionaryFromRow:(char **)row columns:(char **)columns columnCount:(int)columnCount
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
	
	for (int i = 0; i < columnCount; i++) {
		char *val = row[i];
		[dict setValue:val == NULL ? @"" : [NSString stringWithUTF8String:val] forKey:[NSString stringWithUTF8String:columns[i]]];
	}
	
	return dict;
}

- (CSLTable *)tableNamed:(NSString *)name
{
	CSLQueryResults *tableResult = [self executeSQL:[NSString stringWithFormat:@"SELECT name, sql FROM sqlite_master WHERE type='table' and name='%@'", name]];
	
	CSLTable *table = [[CSLTable alloc] initWithName:tableResult.rows[0][0]];
	
	NSArray *columnRows = [self executeSQLGetDictionaryRows:[NSString stringWithFormat:@"pragma table_info(%@)", table.name]];
	
	[columnRows enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
		[table addColumn:[[CSLTableColumn alloc] initWithName:obj[@"name"] type:obj[@"type"] length:0]];
	}];
	
	return table;
}

@end
