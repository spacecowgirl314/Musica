//
//  TrayMenu.h
//  Musica
//
//  Created by Chloe Stars on 9/11/10.
//  Copyright 2010 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferencesController.h"

@interface TrayMenu : NSObject <NSMenuDelegate> {
	PreferencesController *preferencesController;
@private
	NSStatusItem *_statusItem;
}

-(NSMenu *)createMenu;

@property (strong, nonatomic) PreferencesController *preferencesController;

@end
