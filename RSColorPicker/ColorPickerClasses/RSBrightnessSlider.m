//
//  RSBrightnessSlider.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSBrightnessSlider.h"
#import "RSColorPickerView.h"
#import "ANImageBitmapRep.h"

@implementation RSBrightnessSlider

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = 0.0f;
        self.maximumValue = 1.0f;
        self.continuous = YES;
        
        self.enabled = YES;
        self.userInteractionEnabled = YES;
        
        [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)setUseCustomSlider:(BOOL)use {
    if (use) {
        [self setupImages];
    }
}

-(void)myValueChanged:(id)notif {
    [colorPicker setBrightness:self.value];
}

-(void)setupImages {
    ANImageBitmapRep *myRep = [[ANImageBitmapRep alloc] initWithSize:BMPointMake(self.frame.size.width, self.frame.size.height)];
    for (int x = 0; x < myRep.bitmapSize.x; x++) {
        CGFloat percGray = (CGFloat)x / (CGFloat)myRep.bitmapSize.x;
        for (int y = 0; y < myRep.bitmapSize.y; y++) {
            [myRep setPixel:BMPixelMake(percGray, percGray, percGray, 1.0f) atPoint:BMPointMake(x, y)];
        }
    }
    
    //[self setBackgroundColor:[UIColor colorWithPatternImage:[myRep image]]];
    [self setMinimumTrackImage:[myRep image] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[myRep image] forState:UIControlStateNormal];
    
    [myRep release];
}

-(void)setColorPicker:(RSColorPickerView*)cp {
    colorPicker = cp;
    if (!colorPicker) { return; }
    self.value = [colorPicker brightness];
}

@end
