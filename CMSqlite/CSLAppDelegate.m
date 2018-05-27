//
//  CSLAppDelegate.m
//  CMSqlite
//
//  Created by Craig Miller on 22/12/2013.
//
//

#import "CSLAppDelegate.h"

#import "CSLSqliteConnection.h"
#import "CMMADocument.h"

@implementation CSLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	//if (((NSDocumentController *)[NSDocumentController sharedDocumentController]).currentDocument == nil)
	//	[[NSDocumentController sharedDocumentController] openDocument:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}

- (IBAction)runSelectedSQL:(id)sender
{
	CMMADocument *document = ((NSDocumentController *)[NSDocumentController sharedDocumentController]).currentDocument;
	
	[document executeSelectedSQL];
}

- (IBAction)runAllSQL:(id)sender
{
	CMMADocument *document = ((NSDocumentController *)[NSDocumentController sharedDocumentController]).currentDocument;
	
	[document executeAllSQL];
}

@end
