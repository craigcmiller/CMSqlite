//
//  CSLQueryResults.m
//  CMSqlite
//
//  Created by Craig Miller on 24/12/2013.
//
//

#import "CSLQueryResults.h"

@implementation CSLQueryResults

- (id)init
{
	if (self = [super init]) {
		_error = nil;
		_columnNames = [[NSMutableArray alloc] init];
		_rows = [[NSMutableArray alloc] initWithCapacity:4096];
	}
	
	return self;
}

- (void)assignError:(NSString *)error
{
	_error = error;
}

@end
