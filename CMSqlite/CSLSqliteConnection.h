//
//  CSLSqliteConnection
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import <Foundation/Foundation.h>

#import "CSLQueryResults.h"
#import "CSLTable.h"

@interface CSLSqliteConnection : NSObject

- (id)initWithPath:(NSString *)path;

- (void)executeSQL:(NSString *)sql processRow:(BOOL (^)(int columnCount, char **results, char **columns))processRow onError:(void (^)(NSString *error))onError;

- (CSLQueryResults *)executeSQL:(NSString *)sql;

- (void)executeSQLAsync:(NSString *)sql onComplete:(void (^)(CSLQueryResults *results))onComplete;

- (CSLTable *)tableNamed:(NSString *)name;

@property (nonatomic, readonly) BOOL (^processRow)(int columnCount, char **results, char **columns);

@property (nonatomic, readonly) NSArray *tableNames;

@property (atomic, readonly) BOOL executingAsync;

@end
