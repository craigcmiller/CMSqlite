//
//  CSLTable.m
//  CMSqlite
//
//  Created by Craig Miller on 27/12/2013.
//
//

#import "CSLTable.h"

@implementation CSLTable

- (id)initWithName:(NSString *)tableName
{
    self = [super init];
    if (self) {
		_name = tableName;
		_columns = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addColumn:(CSLTableColumn *)column
{
	[(NSMutableArray *)_columns addObject:column];
}

@end
