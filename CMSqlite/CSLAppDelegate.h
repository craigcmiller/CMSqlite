//
//  CSLAppDelegate.h
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface CSLAppDelegate : NSObject<NSApplicationDelegate>

- (IBAction)runSelectedSQL:(id)sender;

- (IBAction)runAllSQL:(id)sender;

@end
