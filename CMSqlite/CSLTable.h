//
//  CSLTable.h
//  CMSqlite
//
//  Created by Craig Miller on 27/12/2013.
//
//

#import <Foundation/Foundation.h>

#import "CSLTableColumn.h"

@interface CSLTable : NSObject

- (id)initWithName:(NSString *)tableName;

- (void)addColumn:(CSLTableColumn *)column;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSArray *columns;

@end
