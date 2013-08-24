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
