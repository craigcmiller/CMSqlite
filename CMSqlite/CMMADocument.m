//
//  CMMADocument.m
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import "CMMADocument.h"

#import "CSLSqliteConnection.h"
#import "CSLDatabaseContentMenuItem.h"
#import "CSLQueryResultsTableViewController.h"
#import "CSLSQLEditorFileManager.h"

// Toolbar item identifiers
static NSString *const kToolbarRunSQL = @"TB_RUN_SQL";

@interface CMMADocument()
{
	NSURL *_url;
	CSLSqliteConnection *_dbConnection;
	CSLDatabaseContentsController *_databaseContentsController;
	CSLQueryResultsTableViewController *_queryResultsTableViewController;
}
@end

@implementation CMMADocument

- (instancetype)init
{
    self = [super init];
    if (self) {
		
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"CMMADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (BOOL)isEntireFileLoaded
{
	return NO;
}

- (BOOL)isDocumentEdited
{
	return NO;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	return YES;
}

- (void)awakeFromNib
{
	[self.documentWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
	
	// Setup SQL editor
	_sqlTextView.tableNames = _dbConnection.tableNames;
	_sqlTextView.sqlEditorFileManager = [[CSLSQLEditorFileManager alloc] initWithDocumentName:[[_url.path lastPathComponent] stringByDeletingPathExtension]];
	
	// Setup toolbar
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"DocumentToolbar"];
	toolbar.delegate = self;
	toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
	toolbar.allowsUserCustomization = YES;
	[toolbar setVisible:YES];
	
	self.documentWindow.toolbar = toolbar;
	
	// Setup database connection outline view controller
	_databaseContentsController = [[CSLDatabaseContentsController alloc] initWithDatabaseConnection:_dbConnection];
	
	CSLDatabaseContentMenuItem *tablesRootMenuItem = [[CSLDatabaseContentMenuItem alloc] initWithTitle:@"Tables" type:CSLDatabaseContentMenuItemTypeTables];
	[_databaseContentsController.rootMenuItem addChild:tablesRootMenuItem];
	
	for (NSString *tableName in _dbConnection.tableNames) {
		CSLDatabaseContentMenuItem *tableMenuItem = [[CSLDatabaseContentMenuItem alloc] initWithTitle:tableName type:CSLDatabaseContentMenuItemTypeTable];
		
		[tablesRootMenuItem addChild:tableMenuItem];
	}
	
//	
//	NSTableColumn *column = [[NSTableColumn alloc] init];
//	[_databaseContentsOutlineView addTableColumn:column];
//	[_databaseContentsOutlineView setOutlineTableColumn:column];
	
	_databaseContentsOutlineView.dataSource = _databaseContentsController;
	_databaseContentsOutlineView.delegate = _databaseContentsController;
	
	[_databaseContentsOutlineView expandItem:nil expandChildren:YES];
}

- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo
{
	[self.sqlTextView save];
	
	[super canCloseDocumentWithDelegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo:contextInfo];
}

- (void)close
{
	[self.sqlTextView save];
	
	[super close];
}

- (void)setFileURL:(NSURL *)url
{
	[super setFileURL:url];
	
	_url = url;
	_dbConnection = [[CSLSqliteConnection alloc] initWithPath:url.path];
}

- (void)executeSelectedSQL
{
	NSString *sql;
	
	if (self.sqlTextView.selectedRange.length > 0)
		sql = [self.sqlTextView.textStorage.string substringWithRange:self.sqlTextView.selectedRange];
	else
		sql = self.sqlTextView.textStorage.string;
	
	[self executeSQL:sql];
}

- (void)executeAllSQL
{
	[self executeSQL:self.sqlTextView.textStorage.string];
}

- (void)executeSQL:(NSString *)sql
{
	if (_dbConnection.executingAsync) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"SQL Currently Executing" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please wait until the SQL currently running has completed"];
		
		[alert beginSheetModalForWindow:self.documentWindow completionHandler:nil];
		
		return;
	}
	
	[_dbConnection executeSQLAsync:sql onComplete:^(CSLQueryResults *results) {
		if (results.error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				NSAlert *alert = [NSAlert alertWithMessageText:@"Error executing SQL" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", results.error];
				
				[alert beginSheetModalForWindow:self.documentWindow completionHandler:nil];
			});
		} else
			[self performSelectorOnMainThread:@selector(updateSQLResultsTableView:) withObject:results waitUntilDone:NO];
	}];
}

- (void)updateSQLResultsTableView:(CSLQueryResults *)queryResults
{
	_queryResultsTableViewController = [[CSLQueryResultsTableViewController alloc] initWithTableView:self.resultsTableView queryResults:queryResults];
}

#pragma Toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	if ([itemIdentifier isEqualToString:kToolbarRunSQL]) {
		NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
		
		toolbarItem.label = @"Run SQL";
		toolbarItem.image = [NSImage imageNamed:@"Run"];
		toolbarItem.target = self;
		toolbarItem.action = @selector(executeSelectedSQL);
		
		return toolbarItem;
	}
	
	return nil;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return @[kToolbarRunSQL];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return @[kToolbarRunSQL];
}

@end
