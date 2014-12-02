//
//  ThemeLoader.h
//  Musica
//
//  Created by Chloe Stars on 7/4/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "NSImage+Retina.h"

@interface ThemeLoader : NSObject
{
	NSMutableArray *themes;
	IBOutlet NSTableView *tableView;
    IBOutlet NSImageView *previewImageView;
    IBOutlet NSTextField *selectedThemeTextField;
}

- (void)reload;
+ (NSURL*)appliedThemeURL;
+ (void)installTheme:(NSURL*)source;
+ (Theme*)currentTheme;

@end
