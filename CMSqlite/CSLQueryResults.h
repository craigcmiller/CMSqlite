//
//  CSLQueryResults.h
//  CMSqlite
//
//  Created by Craig Miller on 24/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface CSLQueryResults : NSObject

- (id)init;

- (void)assignError:(NSString *)error;

@property (nonatomic, readonly) NSMutableArray *columnNames;

@property (nonatomic, readonly) NSMutableArray *rows;

@property (nonatomic, readonly) NSString *error;

@end
