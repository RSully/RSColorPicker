//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerView.h"


// Concept-code from http://www.easyrgb.com/index.php?X=MATH&H=21#text21
BMPixel pixelFromHSV(CGFloat H, CGFloat S, CGFloat V) {
    if (S == 0) {
        return BMPixelMake(V, V, V, 1.0f);
    }
    CGFloat var_h = H * 6.0f;
    if (var_h == 6) {
        var_h = 0.0f;
    }
    CGFloat var_i = floorf(var_h);
    CGFloat var_1 = V * (1 - S);
    CGFloat var_2 = V * (1 - S * (var_h - var_i));
    CGFloat var_3 = V * (1 - S * (1 - (var_h - var_i)));
    
    if (var_i == 0) {
        return BMPixelMake(V, var_3, var_1, 1.0f);
    } else if (var_i == 1) {
        return BMPixelMake(var_2, V, var_1, 1.0f);
    } else if (var_i == 2) {
        return BMPixelMake(var_1, V, var_3, 1.0f);
    } else if (var_i == 3) {
        return BMPixelMake(var_1, var_2, V, 1.0f);
    } else if (var_i == 4) {
        return BMPixelMake(var_3, var_1, V, 1.0f);
    }
    return BMPixelMake(V, var_1, var_2, 1.0f);
}


@interface RSColorPickerView (Private)
-(void)updateSelectionLocation;
@end


@implementation RSColorPickerView

@synthesize brightness, cropToCircle, delegate;

- (id)initWithFrame:(CGRect)frame
{
    CGFloat sqr = fminf(frame.size.height, frame.size.width);
    frame.size = CGSizeMake(sqr, sqr);
    
    self = [super initWithFrame:frame];
    if (self) {
        cropToCircle = YES;
        
        selection = CGPointMake(sqr/2, sqr/2);
        selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
        selectionView.backgroundColor = [UIColor clearColor];
        selectionView.layer.borderWidth = 2.0f;
        selectionView.layer.borderColor = [UIColor colorWithWhite:0.1f alpha:1.0f].CGColor;
        selectionView.layer.cornerRadius = 9.0f;
        [self updateSelectionLocation];
        [self addSubview:selectionView];
        
        self.brightness = 1.0f;
        rep = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(frame.size)];
    }
    return self;
}

-(void)setBrightness:(CGFloat)bright {
    brightness = bright;
    [self setNeedsDisplay];
    [delegate colorPickerDidChangeSelection:self];
}

-(void)setCropToCircle:(BOOL)circle {
    if (circle == cropToCircle) { return; }
    cropToCircle = circle;
    [self setNeedsDisplay];
}

-(void)genBitmap {
    CGFloat radius = (self.frame.size.width / 2);
    CGFloat relX = 0;
    CGFloat relY = 0;
    
    for (int x = 0; x < self.frame.size.width; x++) {
        relX = x - radius;
        
        for (int y = 0; y < self.frame.size.height; y++) {
            relY = radius - y;
            
            CGFloat r_distance = sqrtf((relX * relX)+(relY * relY));
            if (fabsf(r_distance) > radius && cropToCircle == YES) {
                [rep setPixel:BMPixelMake(0.0f, 0.0f, 0.0f, 0.0f) atPoint:BMPointMake(x, y)];
                continue;
            }
            r_distance = fminf(r_distance, radius);
            
            CGFloat angle = atan2f(relY, relX);
            if (angle < 0) { angle = (2*M_PI)+angle; }
            
            CGFloat perc_angle = (angle/(2 * M_PI));
            BMPixel thisPixel = pixelFromHSV(perc_angle, r_distance/radius, self.brightness);
            [rep setPixel:thisPixel atPoint:BMPointMake(x, y)];
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self genBitmap];
    [[rep image] drawInRect:rect];
}


-(UIColor*)selectionColor {
    return UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(selection)]);
}
-(CGPoint)selection {
    return selection;
}

-(void)updateSelectionLocation {
    selectionView.center = selection;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (![self pointInside:point withEvent:event]) { return; }
    
    BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(point)];
    if (pixel.alpha > 0.0f) {
        badTouch = NO;
        selection = point;
        [delegate colorPickerDidChangeSelection:self];
        [self updateSelectionLocation];
    } else {
        [super touchesCancelled:touches withEvent:event];
        badTouch = YES;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (badTouch) { return; }
    CGPoint point = [[touches anyObject] locationInView:self];
    if (![self pointInside:point withEvent:event]) { return; }
    BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(point)];
    if (pixel.alpha > 0.0f) {
        selection = point;
        [delegate colorPickerDidChangeSelection:self];
        [self updateSelectionLocation];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (badTouch) { return; }
    CGPoint point = [[touches anyObject] locationInView:self];
    if (![self pointInside:point withEvent:event]) { return; }
    BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(point)];
    if (pixel.alpha > 0.0f) {
        selection = point;
        [delegate colorPickerDidChangeSelection:self];
        [self updateSelectionLocation];
    }
}



- (void)dealloc
{
    [super dealloc];
}

@end
