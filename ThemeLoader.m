//
//  ThemeLoader.m
//  Musica
//
//  Created by Chloe Stars on 7/4/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "ThemeLoader.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation ThemeLoader

- (id)init
{
    self = [super init];
	if (self)
	{
		themes = [[NSMutableArray alloc] init];
		[self loadThemes];
	}
	
	return self;
}

- (void)reload
{
	[themes removeAllObjects];
	[self loadThemes];
}

- (void)loadThemesWithPath:(NSString*)path
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *enm = [contents objectEnumerator];
    NSString *file;
    while ((file = [enm nextObject])) {
        if ([[file pathExtension] isEqualToString:@"bowtie"]) {
            NSString *themePath = [[NSString alloc] initWithFormat:@"%@/%@", path, file];
            Theme *theme = [[Theme alloc] initWithURL:[NSURL fileURLWithPath:themePath]];
            NSLog(@"Loading bowtie theme: %@ at path %@", [theme name], themePath);
            [themes addObject:theme];
        }
    }
}

- (void)loadThemes
{
	// Load plugins
	// Much more customization needed like the ability to disable plugins.
	NSString *path = [[NSFileManager defaultManager] applicationSupportDirectory];
	path = [[NSString alloc] initWithFormat:@"%@", path];
    [self loadThemesWithPath:path];
    
    path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Themes"];
    [self loadThemesWithPath:path];
	
	[themes sortUsingComparator:^NSComparisonResult(Theme *theme1, Theme *theme2) {
		return [theme1.name compare:theme2.name];
	}];
}

+ (NSURL*)appliedThemeURL
{
    NSString *themePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"musicaTheme"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:themePath])
    {
        return [NSURL fileURLWithPath:themePath];
    }
	else
    {
        return [self defaultThemeURL];
    }
}

+ (NSURL*)defaultThemeURL
{
    return [NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Themes/Default.bowtie"]];
}

+ (Theme*)currentTheme
{
    return [[Theme alloc] initWithURL:[self appliedThemeURL]];
}

+ (void)installTheme:(NSURL*)source
{
	//copy file to application support
	NSLog(@"Opening file %@", source);
	//return YES if we are successful
	NSString *destination = [[NSFileManager defaultManager] applicationSupportDirectory];
	//destination = [[NSString alloc] initWithFormat:@"%@/Themes/%@", destination, [source lastPathComponent]];
	
	// put a confirmation dialog here just make sure to follow semantics from Safari/Dashboard plugin installation.
	NSError *error;
	//[[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
	[[NSFileManager defaultManager] copyItemAtURL:source toURL:[[NSURL fileURLWithPath:destination] URLByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@.bowtie", [[NSUUID UUID] UUIDString]]] error:&error];// [source lastPathComponent]
	if (error!=nil)
	{
		NSLog(@"error description:%@", [error description]);
	}
}

- (IBAction)applySelectedTheme:(id)sender
{
	[[themes objectAtIndex:[tableView selectedRow]] applyTheme];
}

- (IBAction)removeSelectedTheme:(id)sender
{
    [[themes objectAtIndex:[tableView selectedRow]] removeTheme];
    [themes removeObjectAtIndex:[tableView selectedRow]];
    [tableView reloadData];
}

#pragma mark -
#pragma mark NSTableView Data Source Methods
- (int)numberOfRowsInTableView:(NSTableView *)theTableView
{
	// just for demonstration, set an arbitrary number of rows, we don't have any actual data to display
	return themes.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSString *simpleText = [[NSString alloc] initWithFormat:@"%@ by %@", [[themes objectAtIndex:rowIndex] name], [[themes objectAtIndex:rowIndex] artist]];
	NSCell *cell = [[NSCell alloc] initTextCell:simpleText];
	return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    Theme *theme = [themes objectAtIndex:[tableView selectedRow]] ;
    [previewImageView setImage:[[NSImage alloc] initByReferencingURL:[[theme URL] URLByAppendingPathComponent:[theme preview]]]];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 20;
}

@end
