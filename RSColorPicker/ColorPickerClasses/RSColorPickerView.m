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
#define IS_INSIDE(p) CGRectContainsPoint(self.bounds, p)
#define MY_MIN3(x,y,z) MIN(x,MIN(y,z))
#define MY_MAX3(x,y,z) MAX(x,MAX(y,z))

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)


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

@class RSSelectionView;

@interface RSColorPickerView () {
	
	struct {
        unsigned int bitmapNeedsUpdate:1;
        unsigned int badTouch:1;
		unsigned int delegateDidChangeSelection:1;
	} _colorPickerViewFlags;
}

@property (nonatomic) ANImageBitmapRep *rep;
@property (nonatomic) UIBezierPath *gradientShape;

@property (nonatomic) RSSelectionView *selectionView;
@property (nonatomic) UIImageView *gradientView;
@property (nonatomic) UIView *gradientContainer;

@property (nonatomic) BGRSLoupeLayer* loupeLayer;
@property (nonatomic) CGPoint selection;

-(void)initRoutine;
-(void)updateSelectionLocation;
-(CGPoint)validPointForTouch:(CGPoint)touchPoint;

@end

@interface RSSelectionView : UIView
@property (nonatomic) UIColor *selectedColor;
@end
@implementation RSSelectionView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
	}
	return self;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
	_selectedColor = selectedColor;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(ctx, _selectedColor.CGColor);
	CGContextFillEllipseInRect(ctx, CGRectInset(rect, 2, 2));
	CGContextSetLineWidth(ctx, 3);
	CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:0.4].CGColor);
	CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 1.5, 1.5));
	CGContextSetLineWidth(ctx, 2);
	CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:1].CGColor);
	CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 3, 3));
}

@end

@implementation RSColorPickerView

#pragma mark - Object lifecycle

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

-(void)initRoutine
{
	self.opaque = YES;
	self.backgroundColor = [UIColor orangeColor];
	_colorPickerViewFlags.bitmapNeedsUpdate = YES;
		
    _selectionView = [[RSSelectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 22.0, 22.0)];
	_selection = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

	CGRect frame = CGRectInset(self.bounds, _selectionView.frame.size.height / 2.0, _selectionView.frame.size.width / 2.0);

	_gradientContainer = [[UIView alloc] initWithFrame:frame];
	_gradientContainer.backgroundColor = [UIColor blackColor];
	_gradientContainer.layer.shouldRasterize = YES;
	_gradientContainer.layer.contentsScale = [UIScreen mainScreen].scale;
	[self addSubview:_gradientContainer];
	
	_gradientView = [[UIImageView alloc] initWithFrame:_gradientContainer.bounds];
	[_gradientContainer addSubview:_gradientView];
	
    [self updateSelectionLocationDisableActions:NO];
    [self addSubview:_selectionView];

    _rep = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(_gradientView.bounds.size)];
	[self genBitmap];
    
	self.cropToCircle = YES;
    self.brightness = 1.0;
	self.selectionColor = [UIColor whiteColor];
}

#pragma mark - Setters

- (void)setBrightness:(CGFloat)bright {
	_brightness = bright;
	_gradientView.alpha = bright;
	[self updateSelectionAtPoint:_selection];
}

-(void)setCropToCircle:(BOOL)circle {
	_cropToCircle = circle;
	_gradientContainer.layer.cornerRadius = circle ? _gradientContainer.bounds.size.width / 2.0 : 0;
	_gradientShape = circle ? [UIBezierPath bezierPathWithOvalInRect:_gradientContainer.frame] : [UIBezierPath bezierPathWithRect:_gradientContainer.frame];
	[self updateSelectionLocation];
}

-(void)setSelectionColor:(UIColor *)selectionColor
{
	_selectionColor = selectionColor;
	
    // convert to HSV
    CGFloat h, s, v;
	[selectionColor getHue:&h saturation:&s brightness:&v alpha:NULL];
    
    // extract the original point
    CGFloat radius = (_rep.bitmapSize.x / 2.0);
    CGFloat angle = h * (M_PI / 180);
    CGFloat centerDistance = s * radius;
    
    CGFloat pointX = cos(angle) * centerDistance + radius;
    CGFloat pointY = radius - sin(angle) * centerDistance;
    _selection = CGPointMake(pointX, pointY);
    
    [self updateSelectionLocation];
    [self setBrightness:v];
}

- (void)setDelegate:(id<RSColorPickerViewDelegate>)delegate
{
	_delegate = delegate;
	_colorPickerViewFlags.delegateDidChangeSelection = [_delegate respondsToSelector:@selector(colorPickerDidChangeSelection:)];
}

#pragma mark - Business

-(void)genBitmap {
	if (!_colorPickerViewFlags.bitmapNeedsUpdate) return;
    
	CGFloat radius = (_rep.bitmapSize.x / 2.0);
	CGFloat relX = 0.0;
	CGFloat relY = 0.0;
	
	for (int x = 0; x < _rep.bitmapSize.x; x++) {
		relX = x - radius;
		
		for (int y = 0; y < _rep.bitmapSize.y; y++) {
			relY = radius - y;
			
			CGFloat r_distance = sqrt((relX * relX)+(relY * relY));
			r_distance = fmin(r_distance, radius);
			
			CGFloat angle = atan2(relY, relX);
			if (angle < 0.0) { angle = (2.0 * M_PI)+angle; }
			
			CGFloat perc_angle = angle / (2.0 * M_PI);
			BMPixel thisPixel = pixelFromHSV(perc_angle, r_distance/radius, 1); //full brightness
			[_rep setPixel:thisPixel atPoint:BMPointMake(x, y)];
		}
	}
	_colorPickerViewFlags.bitmapNeedsUpdate = NO;
	_gradientView.image = [_rep image];
}

/**
 * Hue saturation and briteness of the selected point
 */
-(void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV {
	[_selectionColor getHue:pH saturation:pS brightness:pV alpha:NULL];
}

-(UIColor*)colorAtPoint:(CGPoint)point {
    if (IS_INSIDE(point)){
        return UIColorFromBMPixel([_rep getPixelAtPoint:BMPointFromPoint(point)]);
    }
    return nil;
}

-(void)updateSelectionLocation {
    [self updateSelectionLocationDisableActions:YES];
}

-(void)updateSelectionLocationDisableActions: (BOOL)disable {
	_selectionView.center = _selection;
	if(disable) {
		[CATransaction setDisableActions:YES];
	}
	_loupeLayer.position = _selection;
	//make loupeLayer sharp on screen
	CGRect loupeFrame = _loupeLayer.frame;
	loupeFrame.origin = CGPointMake(floor(loupeFrame.origin.x), floor(loupeFrame.origin.y));
	_loupeLayer.frame = loupeFrame;
	
	[_loupeLayer setNeedsDisplay];
}

- (void)updateSelectionAtPoint:(CGPoint)point
{
	CGPoint circlePoint = [self validPointForTouch:point];
	
	CGPoint convertedPoint = CGPointMake(circlePoint.x - _gradientContainer.frame.origin.x, circlePoint.y - _gradientContainer.frame.origin.y);
	BMPixel pixel = [_rep getPixelAtPoint:BMPointFromPoint(convertedPoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	_selection = circlePoint;
	UIColor *rgbColor = [UIColor colorWithRed:pixel.red green:pixel.green blue:pixel.blue alpha:1];
	CGFloat h, s, v;
	[rgbColor getHue:&h saturation:&s brightness:&v alpha:NULL];
	_selectionColor = [UIColor colorWithHue:h saturation:s brightness:_brightness alpha:1];
	
	_selectionView.selectedColor = _selectionColor;
	
	if (_colorPickerViewFlags.delegateDidChangeSelection) [_delegate colorPickerDidChangeSelection:self];
	
	[self updateSelectionLocation];
}

-(CGPoint)validPointForTouch:(CGPoint)touchPoint {
	
	CGPoint returnedPoint;
	if ([_gradientShape containsPoint:touchPoint]) {
		returnedPoint = touchPoint;
	} else {
		//we compute the right point on the gradient border
		
		/*		_________
		 *	   |		 |
		 *	   |		 |
		 *     |   /|	 |
		 *	   | r/ |a   |
		 *	   |_/__|____|
		 *	   R/   |A
		 *	   /____|
		 *		 B
		 *
		 * r / R = a / A
		 */
		CGFloat A = touchPoint.y - CGRectGetMidY(_gradientContainer.frame);
		CGFloat B = touchPoint.x - CGRectGetMidX(_gradientContainer.frame);
		CGFloat R = sqrt(pow(B, 2) + pow(A, 2));
		
		CGFloat r;
		if (_cropToCircle) {
			r = _gradientShape.bounds.size.width / 2.0;
		} else {
			CGFloat a = _gradientContainer.bounds.size.height / 2.0;
			r = fabs(a * R / A);
		}
		CGFloat alpha = acos(A / R);
		if (touchPoint.x < CGRectGetMidX(_gradientContainer.frame)) alpha = 2 * M_PI - alpha;
	
		returnedPoint.x = r * cos(alpha);
		returnedPoint.y = r * sin(alpha);
		
		NSLog(@"%@", NSStringFromCGPoint(returnedPoint));
	}
	return CGPointMake(100, 100);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//Lazily load loupeLayer
    if (!_loupeLayer){
        _loupeLayer = [BGRSLoupeLayer layer];
    }
    [_loupeLayer appearInColorPicker:self];
	
	CGPoint point = [[touches anyObject] locationInView:self];
	[self updateSelectionAtPoint:point];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_colorPickerViewFlags.badTouch) return;
	CGPoint point = [[touches anyObject] locationInView:self];
	[self updateSelectionAtPoint:point];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_colorPickerViewFlags.badTouch) {
		CGPoint point = [[touches anyObject] locationInView:self];
		[self updateSelectionAtPoint:point];
	}
	_colorPickerViewFlags.badTouch = NO;
	[_loupeLayer disapear];
}

- (void)dealloc
{
    _loupeLayer = nil;
}

@end
