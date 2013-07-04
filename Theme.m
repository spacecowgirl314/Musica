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
@synthesize URL;

- (void)applyTheme
{
	[[NSUserDefaults standardUserDefaults] setObject:[URL lastPathComponent] forKey:@"musicaTheme"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"loadTheme" object:nil];
}

@end
