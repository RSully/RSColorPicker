//
//  TestColorViewController.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerClasses/RSColorPickerView.h"

@class RSBrightnessSlider;
@class RSOpacitySlider;

@interface TestColorViewController : UIViewController <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) RSOpacitySlider *opacitySlider;
@property (nonatomic) UIView *colorPatch;

@end
