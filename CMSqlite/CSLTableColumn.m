//
//  CSLTableColumn.m
//  CMSqlite
//
//  Created by Craig Miller on 27/12/2013.
//
//

#import "CSLTableColumn.h"

@implementation CSLTableColumn

- (id)initWithName:(NSString *)colName type:(NSString *)colType length:(NSInteger)len
{
    self = [super init];
    if (self) {
		_name = colName;
		_type = colType;
		_length = len;
    }
    return self;
}

@end
