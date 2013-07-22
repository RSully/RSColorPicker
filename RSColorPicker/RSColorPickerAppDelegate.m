//
//  RSColorPickerAppDelegate.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerAppDelegate.h"
#import "RSColorPickerView.h"

@implementation RSColorPickerAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    for (int i = 0; i < 10; i++) {
        int random = 2 + arc4random_uniform(4000+1);
        [RSColorPickerView prepareForDiameter:random];
        [RSColorPickerView prepareForDiameter:random*2];
        [RSColorPickerView prepareForDiameter:random];
        [RSColorPickerView prepareForDiameter:280.0*3];
        [RSColorPickerView prepareForDiameter:280.0*3];
        [RSColorPickerView prepareForDiameter:280.0*3];
        [RSColorPickerView prepareForDiameter:280.0*2];
    }
    
    // Setup root controller as color
    TestColorViewController *rootController = [[TestColorViewController alloc] initWithNibName:nil bundle:nil];

    // Then add it to a nav controller so we can experiment with pushing
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    // Add navigation to our window
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = navController;
    
    // Show the window
	[self.window makeKeyAndVisible];
	return YES;
}

@end
