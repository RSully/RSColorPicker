//
//  RSColorPickerState.h
//  RSColorPicker
//
//  Created by Alex Nichol on 12/16/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSColorFunctions.h"

@interface RSColorPickerState : NSObject {
    CGFloat hue; // H
    CGFloat saturation; // S
    CGFloat brightness; // V
    CGFloat alpha; // A
}

@property (readonly) CGFloat hue, saturation, brightness, alpha;

+ (RSColorPickerState *)stateForPoint:(CGPoint)point size:(CGFloat)size padding:(CGFloat)padding;

- (id)initWithColor:(UIColor *)selectionColor;
- (id)initWithHue:(CGFloat)H saturation:(CGFloat)S brightness:(CGFloat)V alpha:(CGFloat)A;

- (UIColor *)color;

// Calculates the position on a circular HSV color wheel.
- (CGPoint)selectionLocationWithSize:(CGFloat)size padding:(CGFloat)padding;

// modifications
- (RSColorPickerState *)stateBySettingBrightness:(CGFloat)newBright;
- (RSColorPickerState *)stateBySettingAlpha:(CGFloat)newAlpha;
- (RSColorPickerState *)stateBySettingHue:(CGFloat)newHue;
- (RSColorPickerState *)stateBySettingSaturation:(CGFloat)newSaturation;

@end
