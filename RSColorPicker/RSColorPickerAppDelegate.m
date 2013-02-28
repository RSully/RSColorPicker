//
//  RSColorPickerAppDelegate.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerAppDelegate.h"
#import "RSBrightnessSlider.h"

@implementation RSColorPickerAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIViewController *rootController = [[UIViewController alloc] initWithNibName:nil bundle:nil];

	rootController.view.backgroundColor = [UIColor whiteColor];
	
	_colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
	[_colorPicker setDelegate:self];
	[_colorPicker setBrightness:1.0];
	[_colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[_colorPicker setBackgroundColor:[UIColor clearColor]];
	[rootController.view addSubview:_colorPicker];
	
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10.0, 340.0, 300.0, 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[rootController.view addSubview:_brightnessSlider];
	
	_colorPatch = [[UIView alloc] initWithFrame:CGRectMake(10.0, 400.0, 300.0, 30.0)];
	[rootController.view addSubview:_colorPatch];
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = rootController;

	[self.window makeKeyAndVisible];
	return YES;
}

#pragma mark - RSColorPickerView delegate methods

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
	_colorPatch.backgroundColor = [cp selectionColor];
}

@end
