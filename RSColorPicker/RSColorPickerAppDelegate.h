//
//  RSColorPickerAppDelegate.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerClasses/RSColorPickerView.h"

@class RSBrightnessSlider;

@interface RSColorPickerAppDelegate : NSObject <UIApplicationDelegate, RSColorPickerViewDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) UIView *colorPatch;

@end
