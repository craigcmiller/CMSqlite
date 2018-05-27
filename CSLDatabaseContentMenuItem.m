//
//  CSLDatabaseContentMenuItem.m
//  CMSqlite
//
//  Created by Craig Miller on 23/12/2013.
//
//

#import "CSLDatabaseContentMenuItem.h"

@implementation CSLDatabaseContentMenuItem

- (instancetype)initWithTitle:(NSString *)title type:(CSLDatabaseContentMenuItemType)type
{
	if (self = [super init]) {
		_title = title;
		_type = type;
		_children = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addChild:(CSLDatabaseContentMenuItem *)child
{
	[_children addObject:child];
}

@end
