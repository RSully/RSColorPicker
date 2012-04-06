/**  
 * BGRSLoupeLayer.m
 * Copyright (c) 2011, Benjamin Guest.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * -Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * -Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the 
 *  documentation and/or other materials provided with the distribution.
 * -Neither the name of Benjamin Guest nor the names of its 
 *  contributors may be used to endorse or promote products derived from 
 *  this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE. 
 */

#import "BGRSLoupeLayer.h"

#import "RSColorPickerView.h"

@interface BGRSLoupeLayer () //Private Methods
- (void)drawGlintInContext:(CGContextRef)ctx;
@end


@implementation BGRSLoupeLayer

@synthesize loupeCenter, colorPicker;

const CGFloat LOUPE_SIZE = 85, SHADOW_SIZE = 6;
const int NUM_PIXELS = 5, NUM_SKIP = 15;

- (id)init
{
   self = [super init];
   if (self) {
      CGFloat size = LOUPE_SIZE+2*SHADOW_SIZE;
      self.bounds = CGRectMake(-size/2,-size/2,size,size);
      self.anchorPoint = CGPointMake(0.5, LOUPE_SIZE/(LOUPE_SIZE+SHADOW_SIZE) );
    
      //Set Defaults
}
    
   return self;
}

- (void)dealloc{
   self.colorPicker = nil;
   
   [super dealloc];
}

- (void)drawInContext:(CGContextRef)ctx{
   
   const CGFloat rimThickness = 3.0;

   
   //Draw Shadow 
   CGContextSaveGState(ctx);     //Save before shadow
   
   CGSize shadowOffset = CGSizeMake(0,SHADOW_SIZE/2);
   CGContextSetShadowWithColor(ctx, shadowOffset, SHADOW_SIZE/2, [UIColor blackColor].CGColor);
   CGContextAddEllipseInRect(ctx, CGRectMake(-LOUPE_SIZE/2, -LOUPE_SIZE/2, LOUPE_SIZE, LOUPE_SIZE));

   CGContextSetFillColorWithColor(ctx, [colorPicker selectionColor].CGColor);
   CGContextFillPath(ctx);
   
   CGContextRestoreGState(ctx);  //Restore context after shadow
      
   //Create Loupe Circle Path
   CGMutablePathRef circlePath = CGPathCreateMutable();
   const CGFloat radius = LOUPE_SIZE/2;
   CGPathAddArc(circlePath, nil, 0, 0, radius-rimThickness/2, 0, 2*M_PI, YES);
   
   //Create Cliping Area
   CGContextSaveGState(ctx);     //Save context for cliping

   CGContextAddPath(ctx, circlePath);  //Clip gird drawing to inside of loupe
   CGContextClip(ctx);
   
   //Draw Colorfull grid
   [self drawGridInContext:ctx];
   [self drawGlintInContext:ctx];
   
   CGContextRestoreGState(ctx);  //Restor from clip drawing

   //Stroke Rim of Loupe
   CGContextSetLineWidth(ctx, rimThickness);
   CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
   CGContextAddPath(ctx, circlePath);
   CGContextStrokePath(ctx);
   
   //Draw center of rim loupe
   CGContextSetLineWidth(ctx, rimThickness-1);
   CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
   CGContextAddPath(ctx, circlePath);
   CGContextStrokePath(ctx);
   
   //Memory
   CGPathRelease(circlePath);

}

- (void)drawGridInContext:(CGContextRef)ctx{
   
   const CGFloat w = ceilf(LOUPE_SIZE/NUM_PIXELS);
   
   CGPoint currentPoint = [colorPicker selection];
   currentPoint.x -= NUM_PIXELS*NUM_SKIP/2;
   currentPoint.y -= NUM_PIXELS*NUM_SKIP/2;
   int i,j;
   
   //Draw Pixelated Loupe
   for (j=0; j<NUM_PIXELS; j++){
      for (i=0; i<NUM_PIXELS; i++){
         
         CGRect pixelRect = CGRectMake(w*i-LOUPE_SIZE/2, w*j-LOUPE_SIZE/2, w, w);
         CGMutablePathRef pixelPath = CGPathCreateMutable();
         
         
         CGPathAddRect(pixelPath, nil, pixelRect);
         
         //Fill Path
         CGContextAddPath(ctx, pixelPath);
         UIColor* pixelColor = [self.colorPicker colorAtPoint:currentPoint];
         CGContextSetFillColorWithColor(ctx, pixelColor.CGColor);
         CGContextFillPath(ctx);
         
          CGPathRelease(pixelPath);
         //NSLog(@"CurrentPoint x:%f y:%f",currentPoint.x,currentPoint.y);
         
         currentPoint.x += NUM_SKIP;
      }
      currentPoint.x -= NUM_PIXELS*NUM_SKIP;
      currentPoint.y += NUM_SKIP;
   }
   
   //Draw Selection Square
   CGFloat xyOffset = -(w+1)/2;
   CGRect selectedRect = CGRectMake(xyOffset, xyOffset, w, w);
   CGContextAddRect(ctx, selectedRect);
   
   CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
   CGContextSetLineWidth(ctx, 1.0);
   CGContextStrokePath(ctx);
   
   //NSLog(@" ",nil);
}

- (void)drawGlintInContext:(CGContextRef)ctx{
   //Draw Top Glint
   CGFloat radius =      LOUPE_SIZE/2;
   CGFloat glintRadius = 1.50*LOUPE_SIZE;
   CGFloat drop =        0.25*LOUPE_SIZE;
   CGFloat yOff = drop + glintRadius - radius;
   
   //  Calculations
   CGFloat glintAngle1 = acosf((yOff*yOff + glintRadius*glintRadius - radius*radius)
                               /(2*yOff*glintRadius));
   CGFloat glintAngle2 = asinf(glintRadius/radius * sinf(glintAngle1));
   CGFloat glintEdgeHeight = -radius*sinf(glintAngle2-M_PI_2);
   
   //  Add bottom arc
   CGContextAddArc(ctx, 0, yOff, glintRadius, -M_PI_2+glintAngle1, -M_PI_2-glintAngle1, YES);
   
   //  Add top arc
   CGContextAddArc(ctx, 0, 0, radius, -M_PI_2-glintAngle2, -M_PI_2+glintAngle2, NO);
   
   CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
   //CGContextStrokePath(ctx);
   //return;
   
   CGContextClosePath(ctx);
   CGContextSaveGState(ctx);     //Save context for cliping
	CGContextClip (ctx);
   
	CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
	NSArray* colors = [[NSArray alloc] initWithObjects:
							 (id)[UIColor colorWithWhite:1.0 alpha:0.65].CGColor,
							 (id)[UIColor colorWithWhite:1.0 alpha:0.15].CGColor,nil];
   
	CGGradientRef myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
	[colors release];
   
	CGContextDrawLinearGradient(ctx, myGradient ,CGPointMake(0,-radius), CGPointMake(0,-glintEdgeHeight), 0);
   CGGradientRelease(myGradient);
   CGContextRestoreGState(ctx);

   
   //Draw bottom glint
   yOff   = 0.40*LOUPE_SIZE;
   radius = 0.40*LOUPE_SIZE;
   CGPoint glintCenter = CGPointMake(0, yOff);
   
   CGContextAddArc(ctx, 0, yOff, radius, 0, M_2_PI, YES);
   CGContextSaveGState(ctx);     //Save context for cliping
	CGContextClip (ctx);
   
   colors = [[NSArray alloc] initWithObjects:
             (id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor,
             (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,nil];
   
   myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
	[colors release];
   
   CGContextDrawRadialGradient(ctx, myGradient,glintCenter, 0.0, glintCenter, radius, 0.0);
   CGGradientRelease(myGradient);
   CGContextRestoreGState(ctx);
   
   //Release objects
   CGColorSpaceRelease (space);
}

#pragma mark - Animation

- (void)appearInColorPicker:(RSColorPickerView*)aColorPicker{
   if (self.colorPicker != aColorPicker){
      self.colorPicker = aColorPicker;
   }
   //Add Layer to color picker
   [CATransaction setDisableActions:YES];
   self.transform = CATransform3DMakeScale(.1f, .1f, 1.0f);
   [self.colorPicker.layer addSublayer:self];
   
   //Animate Arival
   CGFloat tPts[3] = {0.0f,0.12f,0.2f};
   CGFloat largeSize = 1.4;
   
   //  Expanison
   CABasicAnimation *expand = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   expand.fromValue = [NSNumber numberWithFloat:0.1f];
   expand.toValue   = [NSNumber numberWithFloat:largeSize];
   expand.duration  = tPts[1]-tPts[0];
   expand.beginTime = tPts[0];
   expand.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
   expand.removedOnCompletion = NO;
   expand.fillMode = kCAFillModeForwards;

   //  Slight Contraction
   CABasicAnimation *contract = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   contract.fromValue = [NSNumber numberWithFloat:largeSize];
   contract.toValue   = [NSNumber numberWithFloat:1.0f];
   contract.duration  = tPts[2]-tPts[1];
   contract.beginTime = tPts[1];
   expand.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
   
   //  Create Animation group
   CAAnimationGroup* appear = [CAAnimationGroup new];
   appear.duration = tPts[2]-tPts[0];
   appear.removedOnCompletion = NO;
   appear.fillMode = kCAFillModeForwards;
   appear.animations = [NSArray arrayWithObjects:expand,contract, nil];
   
   // Animate
   [self addAnimation:appear forKey:@"appear"];
   
   //Cleanup
   [appear release];
   
   //CAAnimationGroup* expand = [CAAnimationGroup new];
}

/**
 * Disapear removes the loupe view from the color picker by shrinking it down to zero
 */
static NSString* const kDisapearKey = @"disapear";

- (void)disapear{
   
   CABasicAnimation* disapear = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   disapear.fromValue = [NSNumber numberWithFloat:1.0f];
   disapear.toValue   = [NSNumber numberWithFloat:0.0f];
   disapear.duration  = 0.1f;
   disapear.delegate  = self;
   disapear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
   disapear.removedOnCompletion = NO;
   disapear.fillMode = kCAFillModeForwards;
   [self addAnimation:disapear forKey:kDisapearKey];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   if (anim == [self animationForKey:kDisapearKey]){
      [self removeFromSuperlayer];
   }
}

@end
