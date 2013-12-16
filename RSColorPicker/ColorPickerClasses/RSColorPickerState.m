//
//  RSColorPickerState.m
//  RSColorPicker
//
//  Created by Alex Nichol on 12/16/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerState.h"

@implementation RSColorPickerState

@synthesize hue, saturation, brightness, alpha;

- (UIColor *)color {
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (RSColorPickerState *)stateForPoint:(CGPoint)point size:(CGFloat)size padding:(CGFloat)padding {
    // calculate everything we need to know
    CGPoint relativePoint = CGPointMake(point.x - (size / 2.0), (size / 2.0) - point.y);
    CGFloat radius = sqrt(pow(relativePoint.x, 2) + pow(relativePoint.y, 2));
    if (radius > (size / 2.0) - padding) {
        radius = (size / 2.0) - padding;
    }
    double angle = atan2(relativePoint.y, relativePoint.x);
    if (angle < 0) angle += M_PI * 2;
    return [[RSColorPickerState alloc] initWithHue:(angle / (2.0 * M_PI))
                                        saturation:(radius / ((size / 2.0) - padding))
                                        brightness:1 alpha:1];
}

- (id)initWithColor:(UIColor *)_selectionColor {
    if ((self = [super init])) {
        float rgba[4];
        RSGetComponentsForColor(rgba, _selectionColor);
        UIColor * selectionColor = [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
        [selectionColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    }
    return self;
}

- (id)initWithHue:(CGFloat)H saturation:(CGFloat)S brightness:(CGFloat)V alpha:(CGFloat)A {
    if ((self = [super init])) {
        hue = H;
        saturation = S;
        brightness = V;
        alpha = A;
    }
    return self;
}

- (CGPoint)selectionLocationWithSize:(CGFloat)size padding:(CGFloat)padding {
    // convert to HSV
    CGFloat paddingDistance = padding;
    
    CGFloat radius = size / 2.0;
    CGFloat angle = hue * (2.0 * M_PI);
    CGFloat r_distance = fmax(saturation * (radius - paddingDistance), 0);
    
    CGFloat pointX = (cos(angle) * r_distance) + radius;
    CGFloat pointY = radius - (sin(angle) * r_distance);
    return CGPointMake(pointX, pointY);
}

#pragma mark - Modification -

- (RSColorPickerState *)stateBySettingBrightness:(CGFloat)newBright {
    return [[RSColorPickerState alloc] initWithHue:hue saturation:saturation brightness:newBright alpha:alpha];
}

- (RSColorPickerState *)stateBySettingAlpha:(CGFloat)newAlpha {
    return [[RSColorPickerState alloc] initWithHue:hue saturation:saturation brightness:brightness alpha:newAlpha];
}

- (RSColorPickerState *)stateBySettingHue:(CGFloat)newHue {
    return [[RSColorPickerState alloc] initWithHue:newHue saturation:saturation brightness:brightness alpha:alpha];
}

- (RSColorPickerState *)stateBySettingSaturation:(CGFloat)newSaturation {
    return [[RSColorPickerState alloc] initWithHue:hue saturation:newSaturation brightness:brightness alpha:alpha];
}

@end
