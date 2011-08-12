//
//  RSBrightnessSlider.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSBrightnessSlider.h"
#import "RSColorPickerView.h"

@implementation RSBrightnessSlider

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = 0.0f;
        self.maximumValue = 1.0f;
        self.continuous = YES;
        [self setupImages];
        self.enabled = YES;
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)myValueChanged:(id)notif {
    [colorPicker setBrightness:self.value];
}

-(void)setupImages {
    
}

-(void)setColorPicker:(RSColorPickerView*)cp {
    colorPicker = cp;
    if (!colorPicker) { return; }
    self.value = [colorPicker brightness];
}

@end
