//
//  CSLQueryResultsTableViewController.m
//  CMSqlite
//
//  Created by Craig Miller on 24/12/2013.
//
//

#import "CSLQueryResultsTableViewController.h"

@interface CSLQueryResultsTableViewController()
{
	NSTableView *_tableView;
	CSLQueryResults *_queryResults;
}
@end

@implementation CSLQueryResultsTableViewController

- (instancetype)initWithTableView:(NSTableView *)tableView queryResults:(CSLQueryResults *)queryResults
{
	if (self = [super init]) {
		_tableView = tableView;
		
		_queryResults = queryResults;
		
		// Remove all existing table columns
		while (_tableView.tableColumns.count > 0)
			[tableView removeTableColumn:[tableView.tableColumns lastObject]];
		
		// Add columns
		for (int i = 0; i < _queryResults.columnNames.count; i++) {
			NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%d", i]];
			[column.headerCell setStringValue:_queryResults.columnNames[i]];
			[_tableView addTableColumn:column];
		}
		
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	
	return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return _queryResults.rows.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	int ident = [aTableColumn.identifier intValue];
	
	return _queryResults.rows[rowIndex][ident];
}

@end
