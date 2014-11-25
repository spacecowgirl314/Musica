//
//  Theme.m
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "Theme.h"

@implementation Theme

@synthesize name;
@synthesize artist;
@synthesize preview;
@synthesize URL;

- (id)initWithURL:(NSURL*)url
{
	NSURL *infoPlistURL = [url URLByAppendingPathComponent:@"Info.plist"];
	[self constructWithDictionary:[NSDictionary dictionaryWithContentsOfURL:infoPlistURL] andSourceURL:url];
	return self;
}

- (void)applyTheme
{
	[[NSUserDefaults standardUserDefaults] setObject:[URL relativePath] forKey:@"musicaTheme"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"loadTheme" object:nil];
}

- (void)removeTheme
{
    [[NSFileManager defaultManager] removeItemAtURL:URL error:nil];
}

- (void)constructWithDictionary:(NSDictionary*)themeDictionary andSourceURL:(NSURL*)url
{
	[self setArtist:themeDictionary[@"BTThemeArtist"]];
	[self setName:themeDictionary[@"BTThemeName"]];
    [self setPreview:themeDictionary[@"BTThemePreviewImage"]];
	[self setURL:url];
	if (themeDictionary[@"BTWindowMode"]==nil) {
		[self setWindowMode:ThemeWindowModeNormal];
	} else if([themeDictionary[@"BTWindowMode"] isEqualToString:@"desktop"]) {
		[self setWindowMode:ThemeWindowModeDesktop];
	} else if([themeDictionary[@"BTWindowMode"] isEqualToString:@"normal"]) {
		[self setWindowMode:ThemeWindowModeNormal];
	} else if([themeDictionary[@"BTWindowMode"] isEqualToString:@"top"]) {
		[self setWindowMode:ThemeWindowModeTop];
	}
}

@end
