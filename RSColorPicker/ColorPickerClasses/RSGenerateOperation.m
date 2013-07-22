//
//  GenerateOperation.m
//  RSColorPicker
//
//  Created by Ryan on 7/22/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "RSGenerateOperation.h"
#import "ANImageBitmapRep.h"
#import "RSColorFunctions.h"

@implementation RSGenerateOperation

-(id)init {
    if ((self = [super init])) {
        _didFinish = NO;
    }
    return self;
}

-(void)main {
    // If we have a dependency then we don't actually have work to perform
    if (self.dependencies.count == 1) {
        _didFinish = [[self.dependencies objectAtIndex:0] isFinished];
        return;
    }
    
    CGFloat diameter = self.diameter;
    CGFloat paddingDistance = self.padding;
    BMPoint repSize = BMPointMake(diameter, diameter);
    
    // Create fresh
    ANImageBitmapRep *rep = [[ANImageBitmapRep alloc] initWithSize:repSize];
    
    CGFloat radius = diameter / 2.0;
    CGFloat relRadius = radius - paddingDistance;
    CGFloat relX, relY;

    int i, x, y;
    int arrSize = powf(diameter, 2);
    size_t arrDataSize = sizeof(float) * arrSize;

    // data
    float *preComputeX = (float *)malloc(arrDataSize);
    float *preComputeY = (float *)malloc(arrDataSize);
    // output
    float *atan2Vals = (float *)malloc(arrDataSize);
    float *distVals = (float *)malloc(arrDataSize);

    i = 0;
    for (x = 0; x < diameter; x++) {
        relX = x - radius;
        for (y = 0; y < diameter; y++) {
            relY = radius - y;

            preComputeY[i] = relY;
            preComputeX[i] = relX;
            i++;
        }
    }

    // Use Accelerate.framework to compute
    vvatan2f(atan2Vals, preComputeY, preComputeX, &arrSize);
    vDSP_vdist(preComputeX, 1, preComputeY, 1, distVals, 1, arrSize);

    // Compution done, free these
    free(preComputeX);
    free(preComputeY);

    i = 0;
    for (x = 0; x < diameter; x++) {
        for (y = 0; y < diameter; y++) {
            CGFloat r_distance = fmin(distVals[i], relRadius);

            CGFloat angle = atan2Vals[i];
            if (angle < 0.0) angle = (2.0 * M_PI) + angle;

            CGFloat perc_angle = angle / (2.0 * M_PI);
            BMPixel thisPixel = RSPixelFromHSV(perc_angle, r_distance/relRadius, 1); // full brightness
            [rep setPixel:thisPixel atPoint:BMPointMake(x, y)];

            i++;
        }
    }
    
    // Bitmap generated, free these
    free(atan2Vals);
    free(distVals);
    
    self.bitmap = rep;
    _didFinish = YES;
}

-(BOOL)isConcurrent {
    return YES;
}

-(BOOL)isExecuting {
    return !_didFinish;
}
-(BOOL)isFinished {
    return _didFinish;
}

@end
