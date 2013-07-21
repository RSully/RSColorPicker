//
//  TestColorViewController.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "TestColorViewController.h"
#import "ColorPickerClasses/RSBrightnessSlider.h"
#import "ColorPickerClasses/RSOpacitySlider.h"

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

    self.view.backgroundColor = [self randomColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStyleBordered target:self action:@selector(pushNext:)];
    
    // View that displays color picker (needs to be square)
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(20.0, 10.0, 280.0, 280.0)];
    [_colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
    [_colorPicker setDelegate:self];
    [self.view addSubview:_colorPicker];
    
    // On/off circle or square
    UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 340, 0, 0)];
    [circleSwitch setOn:_colorPicker.cropToCircle];
	[circleSwitch addTarget:self action:@selector(circleSwitchAction:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:circleSwitch];
    
    // View that controls brightness
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleSwitch.frame) + 4, 300.0, 320 - (20 + CGRectGetWidth(circleSwitch.frame)), 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[self.view addSubview:_brightnessSlider];
    
    // View that controls opacity
    _opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleSwitch.frame) + 4, 340.0, 320 - (20 + CGRectGetWidth(circleSwitch.frame)), 30.0)];
    [_opacitySlider setColorPicker:_colorPicker];
    [self.view addSubview:_opacitySlider];


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

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
	_colorPatch.backgroundColor = [cp selectionColor];
    _brightnessSlider.value = [cp brightness];
    _opacitySlider.value = [cp opacity];
}

#pragma mark - User action

- (void)selectRed:(id)sender {
    [_colorPicker setSelectionColor:[UIColor redColor]];
}
- (void)selectGreen:(id)sender {
    [_colorPicker setSelectionColor:[UIColor greenColor]];
}
- (void)selectBlue:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blueColor]];
}
- (void)selectBlack:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blackColor]];
}
- (void)selectWhite:(id)sender {
    [_colorPicker setSelectionColor:[UIColor whiteColor]];
}
- (void)selectPurple:(id)sender {
    [_colorPicker setSelectionColor:[UIColor purpleColor]];
}
- (void)selectCyan:(id)sender {
    [_colorPicker setSelectionColor:[UIColor cyanColor]];
}

- (void)circleSwitchAction:(UISwitch *)s {
	_colorPicker.cropToCircle = s.isOn;
}

#pragma mark - Push the stack

- (void)pushNext:(id)sender {
    TestColorViewController *colorController = [[TestColorViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:colorController animated:YES];
}

#pragma mark - Generated methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Random color for testing

- (UIColor*)randomColor {
    /*
     From https://gist.github.com/kylefox/1689973

     ***
     
     Distributed under The MIT License:
     http://opensource.org/licenses/mit-license.php
     
     Permission is hereby granted, free of charge, to any person obtaining
     a copy of this software and associated documentation files (the
     "Software"), to deal in the Software without restriction, including
     without limitation the rights to use, copy, modify, merge, publish,
     distribute, sublicense, and/or sell copies of the Software, and to
     permit persons to whom the Software is furnished to do so, subject to
     the following conditions:
     
     The above copyright notice and this permission notice shall be
     included in all copies or substantial portions of the Software.
     
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
     LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
     OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
     WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
     */
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
