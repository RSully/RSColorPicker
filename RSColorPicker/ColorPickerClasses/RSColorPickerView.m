//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerView.h"
#import "BGRSLoupeLayer.h"

// point-related macros
#define INNER_P(x) (x < 0 ? ceil(x) : floor(x))
#define IS_INSIDE(p) (round(p.x) >= 0 && round(p.x) < self.frame.size.width && round(p.y) >= 0 && round(p.y) < self.frame.size.height)
#define MY_MIN3(x,y,z) MIN(x,MIN(y,z))
#define MY_MAX3(x,y,z) MAX(x,MAX(y,z))

// Concept-code from http://www.easyrgb.com/index.php?X=MATH&H=21#text21
BMPixel pixelFromHSV(CGFloat H, CGFloat S, CGFloat V) {
	if (S == 0) {
		return BMPixelMake(V, V, V, 1.0);
	}
	CGFloat var_h = H * 6.0;
	if (var_h == 6.0) {
		var_h = 0.0;
	}
	CGFloat var_i = floor(var_h);
	CGFloat var_1 = V * (1.0 - S);
	CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
	CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
	
	if (var_i == 0) {
		return BMPixelMake(V, var_3, var_1, 1.0);
	} else if (var_i == 1) {
		return BMPixelMake(var_2, V, var_1, 1.0);
	} else if (var_i == 2) {
		return BMPixelMake(var_1, V, var_3, 1.0);
	} else if (var_i == 3) {
		return BMPixelMake(var_1, var_2, V, 1.0);
	} else if (var_i == 4) {
		return BMPixelMake(var_3, var_1, V, 1.0);
	}
	return BMPixelMake(V, var_1, var_2, 1.0);
}

void HSVFromPixel(BMPixel pixel, CGFloat* h, CGFloat* s, CGFloat* v) {
    CGFloat rgb_min, rgb_max;
    CGFloat hsv_hue, hsv_val, hsv_sat;
    rgb_min = MY_MIN3(pixel.red, pixel.green, pixel.blue);
    rgb_max = MY_MAX3(pixel.red, pixel.green, pixel.blue);
    
    if (rgb_max == rgb_min) {
        hsv_hue = 0;
    } else if (rgb_max == pixel.red) {
        hsv_hue = 60.0f * ((pixel.green - pixel.blue) / (rgb_max - rgb_min));
        hsv_hue = fmodf(hsv_hue, 360.0f);
    } else if (rgb_max == pixel.green) {
        hsv_hue = 60.0f * ((pixel.blue - pixel.red) / (rgb_max - rgb_min)) + 120.0f;
    } else if (rgb_max == pixel.blue) {
        hsv_hue = 60.0f * ((pixel.red - pixel.green) / (rgb_max - rgb_min)) + 240.0f;
    }
    
    hsv_val = rgb_max;
    if (rgb_max == 0) {
        hsv_sat = 0;
    } else {
        hsv_sat = 1.0 - (rgb_min / rgb_max);
    }
    
    *h = hsv_hue;
    *s = hsv_sat;
    *v = hsv_val;
}


@interface RSColorPickerView (Private)
-(void)initRoutine;
-(void)updateSelectionLocation;
-(CGPoint)validPointForTouch:(CGPoint)touchPoint;
@end


@implementation RSColorPickerView

@synthesize brightness, cropToCircle, delegate;

- (id)initWithFrame:(CGRect)frame {
	CGFloat sqr = fmin(frame.size.height, frame.size.width);
	frame.size = CGSizeMake(sqr, sqr);
	
	self = [super initWithFrame:frame];
	if (self) {
		[self initRoutine];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

-(void)initRoutine {
    CGRect frame = self.frame;
    CGFloat sqr = fmin(frame.size.height, frame.size.width);
    
    cropToCircle = YES;
    badTouch = NO;
    bitmapNeedsUpdate = YES;
    
    selection = CGPointMake(sqr/2, sqr/2);
    selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 18.0, 18.0)];
    selectionView.backgroundColor = [UIColor clearColor];
    selectionView.layer.borderWidth = 2.0;
    selectionView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    selectionView.layer.cornerRadius = 9.0;
    [self updateSelectionLocationDisableActions:NO];
    [self addSubview:selectionView];
    
    self.brightness = 1.0;
    rep = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(frame.size)];
}

-(void)setBrightness:(CGFloat)bright {
	brightness = bright;
	bitmapNeedsUpdate = YES;
	[self setNeedsDisplay];
	[delegate colorPickerDidChangeSelection:self];
}

-(void)setCropToCircle:(BOOL)circle {
	if (circle == cropToCircle) { return; }
	cropToCircle = circle;
    bitmapNeedsUpdate = YES;
	[self setNeedsDisplay];
}

-(void)genBitmap {
	if (!bitmapNeedsUpdate) return;
    
	CGFloat radius = (rep.bitmapSize.x / 2.0);
	CGFloat relX = 0.0;
	CGFloat relY = 0.0;
	
	for (int x = 0; x < rep.bitmapSize.x; x++) {
		relX = x - radius;
		
		for (int y = 0; y < rep.bitmapSize.y; y++) {
			relY = radius - y;
			
			CGFloat r_distance = sqrt((relX * relX)+(relY * relY));
			if (fabsf(r_distance) > radius && cropToCircle == YES) {
				[rep setPixel:BMPixelMake(0.0, 0.0, 0.0, 0.0) atPoint:BMPointMake(x, y)];
				continue;
			}
			r_distance = fmin(r_distance, radius);
			
			CGFloat angle = atan2(relY, relX);
			if (angle < 0.0) { angle = (2.0 * M_PI)+angle; }
			
			CGFloat perc_angle = angle / (2.0 * M_PI);
			BMPixel thisPixel = pixelFromHSV(perc_angle, r_distance/radius, self.brightness);
			[rep setPixel:thisPixel atPoint:BMPointMake(x, y)];
		}
	}
	bitmapNeedsUpdate = NO;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	[self genBitmap];
	[[rep image] drawInRect:rect];
}


-(UIColor*)selectionColor {
    [self genBitmap];
	return UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(selection)]);
}
-(CGPoint)selection {
	return selection;
}
-(void)setSelectionColor:(UIColor *)selectionColor {
    const float* comps = CGColorGetComponents(selectionColor.CGColor);
    BMPixel pixel = BMPixelMake(comps[0], comps[1], comps[2], 1);
    
    // convert to HSV
    CGFloat h, s, v;
    HSVFromPixel(pixel, &h, &s, &v);
    
    // extract the original point
    CGFloat radius = (rep.bitmapSize.x / 2.0);
    CGFloat angle = h * (M_PI / 180);
    CGFloat centerDistance = s * radius;
    
    CGFloat pointX = cos(angle) * centerDistance + radius;
    CGFloat pointY = radius - sin(angle) * centerDistance;
    selection = CGPointMake(pointX, pointY);
    
    [self updateSelectionLocation];
    [self setBrightness:v];
}

/**
 * Hue saturation and briteness of the selected point
 * @Reference: Taken from ars/uicolor-utilities 
 * http://github.com/ars/uicolor-utilities
 */
-(void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV{
	
	//Get red green and blue from selection
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(selection)];
	CGFloat r = pixel.red, b = pixel.blue, g = pixel.green;
	
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (s == 0.0f) {
		// No saturation, so undefined hue
		h = 0.0f;
	} else {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) h = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) h = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ h = 4 + gc - rc;	// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) h += 360.0f;					// Make non-negative
		h /= 360.0f;                                // Convert to decimal
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}

-(UIColor*)colorAtPoint:(CGPoint)point {
    if (IS_INSIDE(point)){
        return UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(point)]);
    }
    return self.backgroundColor;
}

-(CGPoint)validPointForTouch:(CGPoint)touchPoint {
	if (!cropToCircle) {
		//Constrain point to inside of bounds
		touchPoint.x = MIN(CGRectGetMaxX(self.bounds)-1, touchPoint.x);
		touchPoint.x = MAX(CGRectGetMinX(self.bounds),   touchPoint.x);
		touchPoint.y = MIN(CGRectGetMaxX(self.bounds)-1, touchPoint.y);
		touchPoint.y = MAX(CGRectGetMinX(self.bounds),   touchPoint.y);
		return touchPoint;
	}
	
	BMPixel pixel = BMPixelMake(0.0, 0.0, 0.0, 0.0);
	if (IS_INSIDE(touchPoint)) {
		pixel = [rep getPixelAtPoint:BMPointFromPoint(touchPoint)];
	}
	
	if (pixel.alpha > 0.0) {
		return touchPoint;
	}
	
	// the point is invalid, so we will put it in a valid location.
	CGFloat radius = (self.frame.size.width / 2.0);
	CGFloat relX = touchPoint.x - radius;
	CGFloat relY = radius - touchPoint.y;
	CGFloat angle = atan2(relY, relX);
	
	if (angle < 0) { angle = (2.0 * M_PI) + angle; }
	relX = INNER_P(cos(angle) * radius);
	relY = INNER_P(sin(angle) * radius);
	
	while (relX >= radius)  { relX -= 1; }
	while (relX <= -radius) { relX += 1; }
	while (relY >= radius)  { relY -= 1; }
	while (relY <= -radius) { relY += 1; }
	return CGPointMake(round(relX + radius), round(radius - relY));
}

-(void)updateSelectionLocation {
    [self updateSelectionLocationDisableActions:YES];
}

-(void)updateSelectionLocationDisableActions: (BOOL)disable {
   selectionView.center = selection;
   if(disable) {
       [CATransaction setDisableActions:YES];
   }
   loupeLayer.position = selection;
   [loupeLayer setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
   //Lazily load loupeLayer
    if (!loupeLayer){
        loupeLayer = [[BGRSLoupeLayer layer] retain];
    }
    
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel checker = [rep getPixelAtPoint:BMPointFromPoint(point)];
	if (!(checker.alpha > 0.0)) {
		badTouch = YES;
		return;
	}
	badTouch = NO;
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
    [loupeLayer appearInColorPicker:self];
	
    [self updateSelectionLocation];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (badTouch) return;
	
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
	[self updateSelectionLocation];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (badTouch) return;
	
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
    [self updateSelectionLocation];
    [loupeLayer disapear];
}



- (void)dealloc
{
    [rep release];
    [selectionView release];
    [loupeLayer release];
    loupeLayer = nil;
    
    [super dealloc];
}

@end
