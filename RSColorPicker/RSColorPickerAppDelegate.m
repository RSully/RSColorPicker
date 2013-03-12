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
    
	rootController.view.backgroundColor = [UIColor greenColor];
	
    
    // View that displays color picker (needs to be square)
	_colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
	[_colorPicker setDelegate:self];
	[_colorPicker setBrightness:1.0];
	[_colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
	[rootController.view addSubview:_colorPicker];
	
    
    // View that controls brightness
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10.0, 340.0, 300.0, 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[rootController.view addSubview:_brightnessSlider];
	
    
    // View that shows selected color
	_colorPatch = [[UIView alloc] initWithFrame:CGRectMake(10.0, 380.0, 300.0, 30.0)];
	[rootController.view addSubview:_colorPatch];
    
    
    // Buttons for testing
    UIButton *selectRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectRed.frame = CGRectMake(10.0, 420.0, 50.0, 30.0);
    [selectRed setTitle:@"Red" forState:UIControlStateNormal];
    [selectRed addTarget:self action:@selector(selectRed:) forControlEvents:UIControlEventTouchUpInside];
    [rootController.view addSubview:selectRed];
    
    UIButton *selectGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectGreen.frame = CGRectMake(70.0, 420.0, 50.0, 30.0);
    [selectGreen setTitle:@"Green" forState:UIControlStateNormal];
    [selectGreen addTarget:self action:@selector(selectGreen:) forControlEvents:UIControlEventTouchUpInside];
    [rootController.view addSubview:selectGreen];
    
    UIButton *selectBlue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlue.frame = CGRectMake(130.0, 420.0, 50.0, 30.0);
    [selectBlue setTitle:@"Blue" forState:UIControlStateNormal];
    [selectBlue addTarget:self action:@selector(selectBlue:) forControlEvents:UIControlEventTouchUpInside];
    [rootController.view addSubview:selectBlue];
    
    UIButton *selectBlack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlack.frame = CGRectMake(190.0, 420.0, 50.0, 30.0);
    [selectBlack setTitle:@"Black" forState:UIControlStateNormal];
    [selectBlack addTarget:self action:@selector(selectBlack:) forControlEvents:UIControlEventTouchUpInside];
    [rootController.view addSubview:selectBlack];
    
    UIButton *selectWhite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectWhite.frame = CGRectMake(260.0, 420.0, 50.0, 30.0);
    [selectWhite setTitle:@"White" forState:UIControlStateNormal];
    [selectWhite addTarget:self action:@selector(selectWhite:) forControlEvents:UIControlEventTouchUpInside];
    [rootController.view addSubview:selectWhite];
	
    
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

#pragma mark - Select colors

-(void)selectRed:(id)sender {
    [_colorPicker setSelectionColor:[UIColor redColor]];
}
-(void)selectGreen:(id)sender {
    [_colorPicker setSelectionColor:[UIColor greenColor]];
}
-(void)selectBlue:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blueColor]];
}
-(void)selectBlack:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blackColor]];
//    [_colorPicker setSelectionColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
}
-(void)selectWhite:(id)sender {
    [_colorPicker setSelectionColor:[UIColor whiteColor]];
//    [_colorPicker setSelectionColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

@end
