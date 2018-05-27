//
//  CSLSQLEditorView.m
//  CMSqlite
//
//  Created by Craig Miller on 25/12/2013.
//
//

#import "CSLSQLEditorView.h"

@interface CSLSQLEditorView()
{
	NSRegularExpression *_keywordsRegex;
	NSRegularExpression *_tablesRegex;
}
@end

@implementation CSLSQLEditorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		self.font = [NSFont fontWithName:@"Menlo" size:11];
		self.automaticQuoteSubstitutionEnabled = NO;
		
		self.textStorage.delegate = self;
		
		self.keywordColour = [NSColor blueColor];
		self.tablesColour = [NSColor darkGrayColor];
		
		_keywordsRegex = [CSLSQLEditorView buildRegex:@[@"order by", @"group by", @"select", @"select", @"from", @"where",
						  @"outer join", @"join", @"and", @"or", @"not", @"delete", @"insert into", @"update", @"like", @"in", @"create",
						@"table", @"values", @"drop", @"limit"] endRegex:@""];
    }
    return self;
}

- (void)setSqlEditorFileManager:(CSLSQLEditorFileManager *)sqlEditorFileManager
{
	[self setString:sqlEditorFileManager.sql];
	
	_sqlEditorFileManager = sqlEditorFileManager;
}

- (void)setTableNames:(NSArray *)tableNames
{
	_tablesRegex = [CSLSQLEditorView buildRegex:tableNames endRegex:@"(\\.\\w+|;)?"];
}

- (void)textStorageDidProcessEditing:(NSNotification *)aNotification
{
	NSRange area = NSMakeRange(0, [self.textStorage length]);
	
	[self.textStorage removeAttribute:NSForegroundColorAttributeName range:area];
	
	NSArray *matches = [_keywordsRegex matchesInString:self.textStorage.string options:0 range:area];
	
	for (NSTextCheckingResult *match in matches)
		[self.textStorage addAttribute:NSForegroundColorAttributeName value:self.keywordColour range:[match rangeAtIndex:2]];
	
	matches = [_tablesRegex matchesInString:self.textStorage.string options:0 range:area];
	
	for (NSTextCheckingResult *match in matches)
		[self.textStorage addAttribute:NSForegroundColorAttributeName value:self.tablesColour range:[match rangeAtIndex:2]];
}

+ (NSRegularExpression *)buildRegex:(NSArray *)words endRegex:(NSString *)end
{
	NSMutableString *text = [[NSMutableString alloc] init];
	
	[text appendString:@"(\\A|\\s|\\n)+("];
	
	for (NSUInteger i = 0; i < words.count; i++) {
		if (i > 0)
			[text appendString:@"|"];
		
		NSString *word = words[i];
		
		[text appendString:[word stringByReplacingOccurrencesOfString:@" " withString:@"\\s+"]];
	}
	
	[text appendString:@")"];
	
	[text appendString:end];
	
	[text appendString:@"(\\s|\\n|\\(|\\Z)+"];
	
	NSError *err;
	NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:text options:NSRegularExpressionCaseInsensitive error:&err];
	
	return regex;
}

- (void)save
{
	_sqlEditorFileManager.sql = self.textStorage.string;
}

@end
