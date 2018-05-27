//
//  CSLTableColumn.h
//  CMSqlite
//
//  Created by Craig Miller on 27/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface CSLTableColumn : NSObject

- (id)initWithName:(NSString *)colName type:(NSString *)colType length:(NSInteger)len;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSString *type;

@property (nonatomic, readonly) NSInteger length;

@end
