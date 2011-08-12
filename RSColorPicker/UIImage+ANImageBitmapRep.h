//
//  UIImage+ANImageBitmapRep.h
//  ImageBitmapRep
//
//  Created by Alex Nichol on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class ANImageBitmapRep;

#import <UIKit/UIKit.h>

@interface UIImage (ANImageBitmapRep)

+ (UIImage *)imageFromImageBitmapRep:(ANImageBitmapRep *)ibr;
- (ANImageBitmapRep *)imageBitmapRep;
- (UIImage *)imageByScalingToSize:(CGSize)sz;
- (UIImage *)imageFittingFrame:(CGSize)sz;
- (UIImage *)imageFillingFrame:(CGSize)sz;

@end
