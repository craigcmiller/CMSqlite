//
//  CSLSQLEditorFileManager.m
//  CMSqlite
//
//  Created by Craig Miller on 25/12/2013.
//
//

#import "CSLSQLEditorFileManager.h"

@interface CSLSQLEditorFileManager()
{
	NSString *_path;
}
@end

@implementation CSLSQLEditorFileManager

- (id)initWithDocumentName:(NSString *)documentName
{
    self = [super init];
    if (self) {
		NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		
		NSString *sqlDirectoryPath = [documentsPath stringByAppendingPathComponent:@"CMSqlite"];
		
		BOOL isDirectory;
		if (![[NSFileManager defaultManager] fileExistsAtPath:sqlDirectoryPath isDirectory:&isDirectory]) {
			NSError *err;
			[[NSFileManager defaultManager] createDirectoryAtPath:sqlDirectoryPath withIntermediateDirectories:NO attributes:nil error:&err];
		}
		
		_path = [sqlDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sql", documentName]];
    }
    return self;
}

- (NSString *)sql
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:_path]) {
		NSError *err;
		return [[NSString alloc] initWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&err];
	} else
		return @"";
}

- (void)setSql:(NSString *)sql
{
	NSError *err;
	[sql writeToFile:_path atomically:YES encoding:NSUTF8StringEncoding error:&err];
}

@end
