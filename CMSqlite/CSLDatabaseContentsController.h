//
//  CSLDatabaseContentsController
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "CSLSqliteConnection.h"
#import "CSLDatabaseContentMenuItem.h"

@interface CSLDatabaseContentsController : NSObject<NSOutlineViewDataSource, NSOutlineViewDelegate>

- (instancetype)initWithDatabaseConnection:(CSLSqliteConnection *)connection;

@property (nonatomic, readonly) CSLDatabaseContentMenuItem *rootMenuItem;

@end
