//
//  RSViewController.m
//  RSColorPicker
//
//  Created by Baldoph Pourprix on 27/02/2013.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "RSViewController.h"
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"

@interface RSViewController () <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) UIView *colorPatch;

@end

@implementation RSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	_colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
	[_colorPicker setDelegate:self];
	[_colorPicker setBrightness:1.0];
	[_colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[_colorPicker setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:_colorPicker];
	
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10.0, 340.0, 300.0, 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[_brightnessSlider setUseCustomSlider:YES]; // Defaults to NO
	[self.view addSubview:_brightnessSlider];
	
	_colorPatch = [[UIView alloc] initWithFrame:CGRectMake(10.0, 400.0, 300.0, 30.0)];
	[self.view addSubview:_colorPatch];
	
    // example of preloading a color
    // UIColor * aColor = [UIColor colorWithRed:0.803 green:0.4 blue:0.144 alpha:1];
    // [colorPicker setSelectionColor:aColor];
    // [brightnessSlider setValue:[colorPicker brightness]];
}

#pragma mark - RSColorPickerView delegate methods

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
	_colorPatch.backgroundColor = [cp selectionColor];
}

@end
