//
//  Track.m
//  Musica
//
//  Created by Chloe Stars on 6/27/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "Track.h"

@implementation Track

@synthesize title;
@synthesize album;
@synthesize artist;
@synthesize genre;
@synthesize length;

+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	NSString *name = nil;
    if (sel == @selector(property:))
		name = @"property";
	if (sel == @selector(propertyHTML:))
		name = @"property";
	
    return name;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
    if (aSelector == @selector(property:)) return NO;
	if (aSelector == @selector(propertyHTML:)) return NO;
    return YES;
}

- (id)property:(NSString*)key
{
	if ([key isEqualToString:@"title"])
	{
		return self.title;
	}
	if ([key isEqualToString:@"artist"])
	{
		return self.artist;
	}
	if ([key isEqualToString:@"album"])
	{
		return self.album;
	}
	if ([key isEqualToString:@"genre"])
	{
		return self.genre;
	}
	if ([key isEqualToString:@"length"])
	{
		return self.length;
	}
	return nil;
}

- (NSString*)propertyHTML:(NSString*)key
{
	// escape HTML entities
	return [self property:key];
}

@end
