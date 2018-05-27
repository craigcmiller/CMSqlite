//
//  CSLSQLEditorView.h
//  CMSqlite
//
//  Created by Craig Miller on 25/12/2013.
//
//

#import <Cocoa/Cocoa.h>

#import "CSLSQLEditorFileManager.h"

@interface CSLSQLEditorView : NSTextView<NSTextStorageDelegate>

- (void)save;

@property (nonatomic) NSColor *keywordColour;

@property (nonatomic) NSColor *tablesColour;

@property (nonatomic, setter = setTableNames:) NSArray *tableNames;

@property (nonatomic) CSLSQLEditorFileManager *sqlEditorFileManager;

@end
