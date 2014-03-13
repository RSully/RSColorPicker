//
//  TestColorViewController.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//

#import <UIKit/UIKit.h>
#import "ColorPickerClasses/RSColorPickerView.h"
#import "ColorPickerClasses/RSColorFunctions.h"

@class RSBrightnessSlider;
@class RSOpacitySlider;

@interface TestColorViewController : UIViewController <RSColorPickerViewDelegate> {
    BOOL isSmallSize;
}

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) RSOpacitySlider *opacitySlider;
@property (nonatomic) UIView *colorPatch;

@property UILabel *rgbLabel;

@end
