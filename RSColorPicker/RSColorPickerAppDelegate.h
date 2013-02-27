//
//  RSColorPickerAppDelegate.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"

@interface RSColorPickerAppDelegate : NSObject <UIApplicationDelegate, RSColorPickerViewDelegate> {
	RSColorPickerView *colorPicker;
	RSBrightnessSlider *brightnessSlider;
	UIView *colorPatch;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end
