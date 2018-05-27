//
//  CSLDatabaseContentsController
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import "CSLDatabaseContentsController.h"

@interface CSLDatabaseContentsController()
{
	CSLSqliteConnection *_connection;
}
@end

@implementation CSLDatabaseContentsController

- (instancetype)initWithDatabaseConnection:(CSLSqliteConnection *)connection
{
	if (self = [super init]) {
		_connection = connection;
		_rootMenuItem = [[CSLDatabaseContentMenuItem alloc] initWithTitle:nil type:CSLDatabaseContentMenuItemTypeRoot];
	}
	
	return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	CSLDatabaseContentMenuItem *menuItem = item == nil ? _rootMenuItem : item;
	
	return menuItem.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	CSLDatabaseContentMenuItem *menuItem = item == nil ? _rootMenuItem : item;
	
	return menuItem.children.count > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	CSLDatabaseContentMenuItem *menuItem = item == nil ? _rootMenuItem : item;
	
	return menuItem.children.count;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	CSLDatabaseContentMenuItem *menuItem = item == nil ? _rootMenuItem : item;
	
	return menuItem.title;
}

- (void)outlineView:(NSOutlineView *)outlineView didClickTableColumn:(NSTableColumn *)tableColumn
{
	NSLog(@"CLICK");
}

- (void)outlineView:(NSOutlineView *)outlineView didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
	
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
}

@end
