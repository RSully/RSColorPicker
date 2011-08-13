//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import "RSColorPickerView.h"

// point-related macros
#define INNER_P(x) (x < 0 ? ceil(x) : floor(x))
#define IS_INSIDE(p) (round(p.x) >= 0 && round(p.x) < self.frame.size.width && round(p.y) >= 0 && round(p.y) < self.frame.size.height)

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


@interface RSColorPickerView (Private)
-(void)updateSelectionLocation;
-(CGPoint)validPointForTouch:(CGPoint)touchPoint;
@end


@implementation RSColorPickerView

@synthesize brightness, cropToCircle, delegate;

- (id)initWithFrame:(CGRect)frame
{
	CGFloat sqr = fmin(frame.size.height, frame.size.width);
	frame.size = CGSizeMake(sqr, sqr);
	
	self = [super initWithFrame:frame];
	if (self) {
		cropToCircle = YES;
		bitmapNeedsUpdate = YES;
		
		selection = CGPointMake(sqr/2, sqr/2);
		selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 18.0, 18.0)];
		selectionView.backgroundColor = [UIColor clearColor];
		selectionView.layer.borderWidth = 2.0;
		selectionView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
		selectionView.layer.cornerRadius = 9.0;
		[self updateSelectionLocation];
		[self addSubview:selectionView];
		
		self.brightness = 1.0;
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
	if (!bitmapNeedsUpdate) { return; }
	CGFloat radius = (self.frame.size.width / 2.0);
	CGFloat relX = 0.0;
	CGFloat relY = 0.0;
	
	for (int x = 0; x < self.frame.size.width; x++) {
		relX = x - radius;
		
		for (int y = 0; y < self.frame.size.height; y++) {
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
	return UIColorFromBMPixel([rep getPixelAtPoint:BMPointFromPoint(selection)]);
}
-(CGPoint)selection {
	return selection;
}

-(CGPoint)validPointForTouch:(CGPoint)touchPoint {
	if (!cropToCircle) return touchPoint;
	else {
		BMPixel pixel = BMPixelMake(0, 0, 0, 0);
		if (IS_INSIDE(touchPoint)) {
			pixel = [rep getPixelAtPoint:BMPointFromPoint(touchPoint)];
		}
		if (pixel.alpha > 0.0f) {
			return touchPoint;
		} else {
			// the point is invalid, so we will put it in a valid location.
			CGFloat radius = (self.frame.size.width / 2);
			CGFloat relX = touchPoint.x - radius;
			CGFloat relY = radius - touchPoint.y;
			CGFloat angle = atan2f(relY, relX);
			if (angle < 0) { angle = (2*M_PI) + angle; }
			relX = INNER_P(cosf((float)angle) * radius);
			relY = INNER_P(sinf((float)angle) * radius);
			while (relX >= radius) { relX -= 1; }
			while (relX <= -radius) { relX += 1; }
			while (relY >= radius) { relY -= 1; }
			while (relY <= -radius) { relY += 1; }
			return CGPointMake(round(relX + radius), round(radius - relY));
		}
	}
}

-(void)updateSelectionLocation {
	selectionView.center = selection;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
	[self updateSelectionLocation];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
	[self updateSelectionLocation];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint circlePoint = [self validPointForTouch:point];
	
	BMPixel pixel = [rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	selection = circlePoint;
	[delegate colorPickerDidChangeSelection:self];
	[self updateSelectionLocation];
}



- (void)dealloc
{
	[rep release];
	[selectionView release];
	[super dealloc];
}

@end
