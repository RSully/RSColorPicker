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

@class RSGradientDelegate;

@interface RSColorPickerView () {
	
	struct {
        unsigned int bitmapNeedsUpdate:1;
        unsigned int badTouch:1;
		unsigned int delegateDidChangeSelection:1;
	} _colorPickerViewFlags;
}

@property (nonatomic) ANImageBitmapRep *rep;
@property (nonatomic) UIImage *gradientImage;
@property (nonatomic) UIBezierPath *gradientPath;
@property (nonatomic) UIColor *blackColor;
@property (nonatomic) RSGradientDelegate *gradientDelegate;

@property (nonatomic) UIView *selectionView;
@property (nonatomic) CALayer *gradientLayer;

@property (nonatomic) BGRSLoupeLayer* loupeLayer;
@property (nonatomic) CGPoint selection;

-(void)initRoutine;
-(void)updateSelectionLocation;
-(CGPoint)validPointForTouch:(CGPoint)touchPoint;

@end

@interface RSGradientDelegate : NSObject
@property (nonatomic, weak) RSColorPickerView *pickerView;
@end
@implementation RSGradientDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	CGRect bounds = (CGRect) { CGPointZero, layer.bounds.size };
	CGContextTranslateCTM(ctx, 0, bounds.size.height);
	CGContextScaleCTM(ctx, 1, -1);
	CGContextSetFillColorWithColor(ctx, _pickerView.backgroundColor.CGColor);
	CGContextFillRect(ctx, bounds);
	CGContextAddPath(ctx, _pickerView.gradientPath.CGPath);
	CGContextClip(ctx);
	CGContextSetFillColorWithColor(ctx, _pickerView.blackColor.CGColor);
	CGContextFillRect(ctx, bounds);
	CGContextSetAlpha(ctx, _pickerView.brightness);
	CGContextDrawImage(ctx, _pickerView.gradientPath.bounds, _pickerView.gradientImage.CGImage);
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

-(void)initRoutine {
    
    self.cropToCircle = YES;
	_colorPickerViewFlags.bitmapNeedsUpdate = YES;
    
    _selection = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 18.0, 18.0)];
    _selectionView.layer.borderWidth = 2.0;
    _selectionView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    _selectionView.layer.cornerRadius = 9.0;
	_selectionView.layer.shouldRasterize = YES;
	_selectionView.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	_blackColor = [UIColor blackColor];
	
	_gradientDelegate = [RSGradientDelegate new];
	_gradientDelegate.pickerView = self;
	
	_gradientLayer = [CALayer layer];
	
	/* we set the gradientLayer frame smaller than the view frame so the the selectionView can go out of the gradient's
	 * bounds and still be selectable */
	_gradientLayer.bounds = (CGRect) { CGPointZero, self.bounds.size };
	_gradientLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	_gradientLayer.delegate = _gradientDelegate;
	[self.layer addSublayer:_gradientLayer];

    [self updateSelectionLocationDisableActions:NO];
    [self addSubview:_selectionView];
    
    self.brightness = 1.0;
    _rep = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(_gradientLayer.bounds.size)];
	[self genBitmap];
}

#pragma mark - Setters

- (void)setBrightness:(CGFloat)bright {
	_brightness = bright;
	[_gradientLayer setNeedsDisplay];
	[self updateSelectionAtPoint:_selection];
}

-(void)setCropToCircle:(BOOL)circle {
	_cropToCircle = circle;
	CGRect frame = CGRectInset(self.bounds, _selectionView.frame.size.height / 2.0, _selectionView.frame.size.width / 2.0);
	_gradientPath = circle ? [UIBezierPath bezierPathWithOvalInRect:frame] : [UIBezierPath bezierPathWithRect:frame];
	[_gradientLayer setNeedsDisplay];
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
	_gradientImage = [_rep image];
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

-(CGPoint)validPointForTouch:(CGPoint)touchPoint {
	
	CGRect bounds = _gradientPath.bounds;
	
	if (!_cropToCircle) {
		//Constrain point to inside of bounds
		touchPoint.x = MIN(CGRectGetMaxX(bounds)-1, touchPoint.x);
		touchPoint.x = MAX(CGRectGetMinX(bounds),   touchPoint.x);
		touchPoint.y = MIN(CGRectGetMaxX(bounds)-1, touchPoint.y);
		touchPoint.y = MAX(CGRectGetMinX(bounds),   touchPoint.y);
		return touchPoint;
	}
	
	BMPixel pixel = BMPixelMake(0.0, 0.0, 0.0, 0.0);
	if (IS_INSIDE(touchPoint)) {
		pixel = [_rep getPixelAtPoint:BMPointFromPoint(touchPoint)];
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
	
	BMPixel pixel = [_rep getPixelAtPoint:BMPointFromPoint(circlePoint)];
	NSAssert(pixel.alpha >= 0.0, @"-validPointForTouch: returned invalid point.");
	
	_selection = circlePoint;
	UIColor *rgbColor = [UIColor colorWithRed:pixel.red green:pixel.green blue:pixel.blue alpha:1];
	CGFloat h, s, v;
	[rgbColor getHue:&h saturation:&s brightness:&v alpha:NULL];
	_selectionColor = [UIColor colorWithHue:h saturation:s brightness:_brightness alpha:1];
	
	_selectionView.backgroundColor = _selectionColor;
	
	if (_colorPickerViewFlags.delegateDidChangeSelection) [_delegate colorPickerDidChangeSelection:self];

	[self updateSelectionLocation];
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
