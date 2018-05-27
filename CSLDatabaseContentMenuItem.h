//
//  CSLDatabaseContentMenuItem.h
//  CMSqlite
//
//  Created by Craig Miller on 23/12/2013.
//
//

#import <Foundation/Foundation.h>

typedef enum {
	CSLDatabaseContentMenuItemTypeRoot,
	CSLDatabaseContentMenuItemTypeTables,
	CSLDatabaseContentMenuItemTypeTable
} CSLDatabaseContentMenuItemType;

@interface CSLDatabaseContentMenuItem : NSObject

- (instancetype)initWithTitle:(NSString *)title type:(CSLDatabaseContentMenuItemType)type;

- (void)addChild:(CSLDatabaseContentMenuItem *)child;

@property (nonatomic, strong) void (^selectedAction)(CSLDatabaseContentMenuItem *menuItem);

@property (nonatomic, readonly) NSString *title;

@property (nonatomic) void *userData;

@property (nonatomic, readonly) CSLDatabaseContentMenuItemType type;

@property (nonatomic, readonly) NSMutableArray *children;

@end
