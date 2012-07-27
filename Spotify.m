//Translated from http://www.jacktams.net/2009/05/15/controlling-spotify-through-applescript-quicksilver/
// Updated but incompatibly translated version http://www.jacktams.net/2009/10/09/spotify-applescripts-updated/
//Modified to menu bar item 6 because 5 didn't work
//Play Next

#import "SPGlue/SPGlue.h"
SPApplication *spotify = [SPApplication applicationWithName: @"Spotify"];
id result = [[spotify activate] send];

#import "SEGlue/SEGlue.h"
SEApplication *systemEvents = [SEApplication applicationWithName: @"System Events"];
SEReference *ref = [[[[[[[[[[systemEvents processes] byName: @"Spotify"] menuBars] at: 1] menuBarItems] at: 6] menus] at: 1] menuItems] at: 3];
id result = [[ref click] send];

//Play Previous

#import "SPGlue/SPGlue.h"
SPApplication *spotify = [SPApplication applicationWithName: @"Spotify"];
id result = [[spotify activate] send];

#import "SEGlue/SEGlue.h"
SEApplication *systemEvents = [SEApplication applicationWithName: @"System Events"];
SEReference *ref = [[[[[[[[[[systemEvents processes] byName: @"Spotify"] menuBars] at: 1] menuBarItems] at: 6] menus] at: 1] menuItems] at: 4];
id result = [[ref click] send];

//Play/Pause

#import "SPGlue/SPGlue.h"
SPApplication *spotify = [SPApplication applicationWithName: @"Spotify"];
id result = [[spotify activate] send];

#import "SEGlue/SEGlue.h"
SEApplication *systemEvents = [SEApplication applicationWithName: @"System Events"];
SEReference *ref = [[[[[[[[[[systemEvents processes] byName: @"Spotify"] menuBars] at: 1] menuBarItems] at: 6] menus] at: 1] menuItems] at: 1];
id result = [[ref click] send];