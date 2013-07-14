//
//  TestColorViewController.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "TestColorViewController.h"
#import "ColorPickerClasses/RSBrightnessSlider.h"

@interface TestColorViewController ()

@end

@implementation TestColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // View that displays color picker (needs to be square)
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
    [_colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
	[_colorPicker setDelegate:self];
	[self.view addSubview:_colorPicker];
	
    
    // On/off circle or square
    UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 340, 0, 0)];
    [circleSwitch setOn:_colorPicker.cropToCircle];
	[circleSwitch addTarget:self action:@selector(circleSwitchAction:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:circleSwitch];
    
    // View that controls brightness
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleSwitch.frame) + 4, 340.0, 320 - (20 + CGRectGetWidth(circleSwitch.frame)), 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[self.view addSubview:_brightnessSlider];
    
    // View that shows selected color
	_colorPatch = [[UIView alloc] initWithFrame:CGRectMake(160, 380.0, 150, 30.0)];
	[self.view addSubview:_colorPatch];
    
    
    // Buttons for testing
    UIButton *selectRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectRed.frame = CGRectMake(10.0, 380.0, 30.0, 30.0);
    [selectRed setTitle:@"R" forState:UIControlStateNormal];
    [selectRed addTarget:self action:@selector(selectRed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectRed];
    
    UIButton *selectGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectGreen.frame = CGRectMake(50.0, 380.0, 30.0, 30.0);
    [selectGreen setTitle:@"G" forState:UIControlStateNormal];
    [selectGreen addTarget:self action:@selector(selectGreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectGreen];
    
    UIButton *selectBlue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlue.frame = CGRectMake(90.0, 380.0, 30.0, 30.0);
    [selectBlue setTitle:@"B" forState:UIControlStateNormal];
    [selectBlue addTarget:self action:@selector(selectBlue:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBlue];
    
    UIButton *selectBlack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlack.frame = CGRectMake(10, 420.0, 50.0, 30.0);
    [selectBlack setTitle:@"Black" forState:UIControlStateNormal];
    [selectBlack addTarget:self action:@selector(selectBlack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBlack];
    
    UIButton *selectWhite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectWhite.frame = CGRectMake(CGRectGetMaxX(selectBlack.frame) + 10, 420.0, 50.0, 30.0);
    [selectWhite setTitle:@"White" forState:UIControlStateNormal];
    [selectWhite addTarget:self action:@selector(selectWhite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectWhite];
    
    UIButton *selectPurple = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectPurple.frame = CGRectMake(CGRectGetMaxX(selectWhite.frame) + 10, 420.0, 50.0, 30.0);
    [selectPurple setTitle:@"Purple" forState:UIControlStateNormal];
    [selectPurple addTarget:self action:@selector(selectPurple:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectPurple];
    
    UIButton *selectCyan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectCyan.frame = CGRectMake(CGRectGetMaxX(selectPurple.frame) + 10, 420.0, 50.0, 30.0);
    [selectCyan setTitle:@"Cyan" forState:UIControlStateNormal];
    [selectCyan addTarget:self action:@selector(selectCyan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectCyan];
}

#pragma mark - RSColorPickerView delegate methods

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
	_colorPatch.backgroundColor = [cp selectionColor];
    _brightnessSlider.value = [cp brightness];
}

#pragma mark - User action

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
}
-(void)selectWhite:(id)sender {
    [_colorPicker setSelectionColor:[UIColor whiteColor]];
}
-(void)selectPurple:(id)sender {
    [_colorPicker setSelectionColor:[UIColor purpleColor]];
}
-(void)selectCyan:(id)sender {
    [_colorPicker setSelectionColor:[UIColor cyanColor]];
}

- (void)circleSwitchAction:(UISwitch *)s
{
	_colorPicker.cropToCircle = s.isOn;
}

#pragma mark - Generated methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
