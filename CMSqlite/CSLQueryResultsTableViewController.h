//
//  CSLQueryResultsTableViewController.h
//  CMSqlite
//
//  Created by Craig Miller on 24/12/2013.
//
//

#import <Foundation/Foundation.h>

#import "CSLQueryResults.h"

@interface CSLQueryResultsTableViewController : NSObject<NSTableViewDataSource, NSTableViewDelegate>

- (instancetype)initWithTableView:(NSTableView *)tableView queryResults:(CSLQueryResults *)queryResults;

@end
