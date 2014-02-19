//
//  RSColorFunctions.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/12/13.
//

#import <UIKit/UIKit.h>
#import "ANImageBitmapRep.h"

BMPixel RSPixelFromHSV(CGFloat H, CGFloat S, CGFloat V);
void RSHSVFromPixel(BMPixel pixel, CGFloat *h, CGFloat *s, CGFloat *v);

// four floats will be placed into `components`
void RSGetComponentsForColor(float *components, UIColor *color);

UIImage * RSUIImageWithScale(UIImage *img, CGFloat scale);

UIImage * RSOpacityBackgroundImage(CGFloat length, UIColor *color);
