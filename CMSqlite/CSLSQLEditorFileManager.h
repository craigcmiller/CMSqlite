//
//  CSLSQLEditorFileManager.h
//  CMSqlite
//
//  Created by Craig Miller on 25/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface CSLSQLEditorFileManager : NSObject

- (id)initWithDocumentName:(NSString *)documentName;

@property (nonatomic) NSString *sql;

@end
