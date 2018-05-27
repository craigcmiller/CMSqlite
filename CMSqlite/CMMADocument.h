//
//  CMMADocument.h
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import <Cocoa/Cocoa.h>

#import "CSLDatabaseContentsController.h"
#import "CSLSQLEditorView.h"

@interface CMMADocument : NSDocument<NSToolbarDelegate>

- (void)executeSelectedSQL;

- (void)executeAllSQL;

@property (weak) IBOutlet NSOutlineView *databaseContentsOutlineView;

@property (weak) IBOutlet NSWindow *documentWindow;

@property (weak) IBOutlet NSTableView *resultsTableView;

@property (unsafe_unretained) IBOutlet CSLSQLEditorView *sqlTextView;

@end
