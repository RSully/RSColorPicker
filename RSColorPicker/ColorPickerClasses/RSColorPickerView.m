//
//  RSColorPickerView.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import "RSColorPickerView.h"
#import "BGRSLoupeLayer.h"
#import "RSSelectionView.h"
#import "RSColorFunctions.h"
#import "ANImageBitmapRep.h"
#import "RSGenerateOperation.h"
#import "RSColorPickerState.h"

#define kSelectionViewSize 22

@interface RSColorPickerView () {
    struct {
        unsigned int bitmapNeedsUpdate:1;
        unsigned int delegateDidChangeSelection:1;
    } _colorPickerViewFlags;
    RSColorPickerState * state;
}

@property (nonatomic) ANImageBitmapRep *rep;

/**
 * A path which represents the shape of the color picker palette,
 * padded by 1/2 the selectionViews's size.
 */
@property (nonatomic) UIBezierPath *activeAreaShape;

@property (nonatomic) RSSelectionView *selectionView;

/**
 * The image view which will ultimately contain the generated
 * palette image.
 */
@property (nonatomic) UIImageView *gradientView;

/**
 * The view which contains there levels:
 * - brightnessView: a black UIView
 * - gradientView: the palette image
 * - opacityView: a checkerboard pattern
 */
@property (nonatomic) UIView *gradientContainer;

/**
 * A black UIView. As the brightness is lowered, the opacity
 * of gradientView is lowered and thus this view becomes more
 * visible.
 */
@property (nonatomic) UIView *brightnessView;

/**
 * A checkerboard pattern indicating opacity.
 * As opacity is lowered, the alpha of this view becomes
 * closer to 1.
 */
@property (nonatomic) UIView *opacityView;

@property (nonatomic) BGRSLoupeLayer *loupeLayer;

/**
 * Gets updated to the scale of the current UIWindow.
 */
@property (nonatomic) CGFloat scale;

- (void)initRoutine;
- (void)resizeOrRescale;

// Called to generate the _rep ivar and set it.
- (void)genBitmap;

// Called to generate the bezier paths
- (void)generateBezierPaths;

// Called to update the UI for the current state.
- (void)handleStateChanged;

// Called to handle a state change (optionally disabling CA Actions for loupe).
- (void)handleStateChangedDisableActions:(BOOL)disable;

// touch handling
- (CGPoint)validPointForTouch:(CGPoint)touchPoint;
- (RSColorPickerState *)stateForPoint:(CGPoint)point;
- (void)updateStateForTouchPoint:(CGPoint)point;

// metrics
- (CGFloat)paddingDistance;
- (CGFloat)paletteDiameter;

@end


@implementation RSColorPickerView

#pragma mark - Object Lifecycle -

- (id)initWithFrame:(CGRect)frame {
    CGFloat square = fmin(frame.size.height, frame.size.width);
    frame.size = CGSizeMake(square, square);

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

- (void)initRoutine {

    // Show or hide the loupe. Default: show.
    _showLoupe = YES;

    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    _colorPickerViewFlags.bitmapNeedsUpdate = NO;

    // the view used to select the colour
    _selectionView = [[RSSelectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, kSelectionViewSize, kSelectionViewSize)];

    _gradientContainer = [[UIView alloc] initWithFrame:self.bounds];
    _gradientContainer.backgroundColor = [UIColor blackColor];
    _gradientContainer.clipsToBounds = YES;
    _gradientContainer.exclusiveTouch = YES;
    _gradientContainer.layer.shouldRasterize = YES;
    [self addSubview:_gradientContainer];

    _brightnessView = [[UIView alloc] initWithFrame:self.bounds];
    _brightnessView.backgroundColor = [UIColor blackColor];
    [_gradientContainer addSubview:_brightnessView];

    _gradientView = [[UIImageView alloc] initWithFrame:_gradientContainer.bounds];
    [_gradientContainer addSubview:_gradientView];

    UIImage *opacityBackground = RSOpacityBackgroundImage(20, [UIColor colorWithWhite:0.5 alpha:1.0]);
    _opacityView = [[UIView alloc] initWithFrame:self.bounds];
    _opacityView.backgroundColor = [UIColor colorWithPatternImage:opacityBackground];
    [_gradientContainer addSubview:_opacityView];

    [self handleStateChangedDisableActions:NO];
    [self addSubview:_selectionView];

    [self setCropToCircle:NO];
    self.selectionColor = [UIColor whiteColor];
}

- (void)resizeOrRescale {
    if (!self.window || self.frame.size.width == 0 || self.frame.size.height == 0) {
        _scale = 0;
        [_loupeLayer disappearAnimated:NO];
        return;
    }

    // Anything that depends on _scale to init needs to be here
    _scale = self.window.screen.scale;
    _gradientContainer.layer.contentsScale = _scale;

    _colorPickerViewFlags.bitmapNeedsUpdate = YES;
    _gradientContainer.frame = self.bounds;
    _gradientView.frame = self.bounds;
    _brightnessView.frame = self.bounds;
    _opacityView.frame = self.bounds;

    [self genBitmap];
    [self generateBezierPaths];
    [self handleStateChanged];
}

- (void)didMoveToWindow {
    [self resizeOrRescale];
}

- (void)setFrame:(CGRect)frame {
    NSAssert(frame.size.width == frame.size.height, @"RSColorPickerView must be square.");
    [super setFrame:frame];
    [self resizeOrRescale];
}

#pragma mark - Business -

- (void)genBitmap {
    if (!_colorPickerViewFlags.bitmapNeedsUpdate) return;

    _rep = [[self class] bitmapForDiameter:_gradientView.bounds.size.width scale:_scale padding:[self paddingDistance] shouldCache:YES];

    _colorPickerViewFlags.bitmapNeedsUpdate = NO;
    _gradientView.image = RSUIImageWithScale([_rep image], _scale);
}

- (void)generateBezierPaths {
    CGRect activeAreaFrame = CGRectInset(_gradientContainer.frame, [self paddingDistance], [self paddingDistance]);
    if (_cropToCircle) {
        _gradientContainer.layer.cornerRadius = [self paletteDiameter] / 2.0;
        _activeAreaShape = [UIBezierPath bezierPathWithOvalInRect:activeAreaFrame];
    } else {
        _gradientContainer.layer.cornerRadius = 0.0;
        _activeAreaShape = [UIBezierPath bezierPathWithRect:activeAreaFrame];
    }
}

#pragma mark - Getters -

- (UIColor *)colorAtPoint:(CGPoint)point {
    return [self stateForPoint:point].color;
}

- (CGFloat)brightness {
    return state.brightness;
}

- (CGFloat)opacity {
    return state.alpha;
}

- (UIColor *)selectionColor {
    return state.color;
}

- (CGPoint)selection {
    return [state selectionLocationWithSize:[self paletteDiameter] padding:[self paddingDistance]];
}

#pragma mark - Setters -

- (void)setSelection:(CGPoint)selection {
    [self updateStateForTouchPoint:selection];
}

- (void)setBrightness:(CGFloat)bright {
    state = [state stateBySettingBrightness:bright];
    [self handleStateChanged];
}

- (void)setOpacity:(CGFloat)opacity {
    state = [state stateBySettingAlpha:opacity];
    [self handleStateChanged];
}

- (void)setCropToCircle:(BOOL)circle {
    _cropToCircle = circle;

    [self generateBezierPaths];
    if (circle) {
        // there's a chance the selection was outside the bounds
        CGPoint point = [self validPointForTouch:[state selectionLocationWithSize:[self paletteDiameter]
                                                                          padding:[self paddingDistance]]];
        [self updateStateForTouchPoint:point];
    } else {
        [self handleStateChanged];
    }
}

- (void)setSelectionColor:(UIColor *)selectionColor {
    state = [[RSColorPickerState alloc] initWithColor:selectionColor];
    [self handleStateChanged];
}

- (void)setDelegate:(id<RSColorPickerViewDelegate>)delegate {
    _delegate = delegate;
    _colorPickerViewFlags.delegateDidChangeSelection = [_delegate respondsToSelector:@selector(colorPickerDidChangeSelection:)];
}

#pragma mark - Selection Updates -

- (void)handleStateChanged {
    [self handleStateChangedDisableActions:YES];
}

- (void)handleStateChangedDisableActions:(BOOL)disable {
    if (disable) {
        NSDictionary *disabledActions = @{@"position" : [NSNull null], @"frame" : [NSNull null], @"center" : [NSNull null]};
        _loupeLayer.actions = disabledActions;
        _selectionView.layer.actions = disabledActions;
    }

    // update positions
    CGPoint selectionLocation = [state selectionLocationWithSize:[self paletteDiameter] padding:[self paddingDistance]];
    _selectionView.center = selectionLocation;
    _loupeLayer.position = selectionLocation;

    // Make loupeLayer sharp on screen
    CGRect loupeFrame = _loupeLayer.frame;
    loupeFrame.origin = CGPointMake(round(loupeFrame.origin.x), round(loupeFrame.origin.y));
    _loupeLayer.frame = loupeFrame;
    [_loupeLayer setNeedsDisplay];

    // re-enable actions
    _loupeLayer.actions = nil;
    _selectionView.layer.actions = nil;

    // set colors and opacities
    _selectionView.selectedColor = [self selectionColor];
    _gradientView.alpha = self.brightness;
    _opacityView.alpha = 1 - self.opacity;

    // notify delegate
    if (_colorPickerViewFlags.delegateDidChangeSelection) {
        [_delegate colorPickerDidChangeSelection:self];
    }
}

- (void)updateStateForTouchPoint:(CGPoint)point {
    point = [self validPointForTouch:point];
    state = [self stateForPoint:point];
    [self handleStateChanged];
}

#pragma mark - Metrics -

- (CGFloat)paddingDistance {
    return kSelectionViewSize / 2.0;
}

- (CGFloat)paletteDiameter {
    return _gradientContainer.frame.size.width;
}

#pragma mark - Touch Events -

- (CGPoint)validPointForTouch:(CGPoint)touchPoint {
    if ([_activeAreaShape containsPoint:touchPoint]) {
        return touchPoint;
    }

    if (_cropToCircle) {
        // We compute the right point on the gradient border
        CGPoint returnedPoint;

        // TouchCircle is the circle which pass by the point 'touchPoint', of radius 'r'
        // 'X' is the x coordinate of the touch in TouchCircle
        CGFloat X = touchPoint.x - CGRectGetMidX(_gradientContainer.frame);
        // 'Y' is the y coordinate of the touch in TouchCircle
        CGFloat Y = touchPoint.y - CGRectGetMidY(_gradientContainer.frame);
        CGFloat r = sqrt(pow(X, 2) + pow(Y, 2));

        // alpha is the angle in radian of the touch on the unit circle
        CGFloat alpha = acos( X / r );
        if (touchPoint.y > CGRectGetMidX(_gradientContainer.frame)) alpha = 2 * M_PI - alpha;

        // 'actual radius' is the distance between the center and the border of the gradient
        CGFloat actualRadius = [self paletteDiameter] / 2.0 - [self paddingDistance];

        returnedPoint.x = fabs(actualRadius) * cos(alpha);
        returnedPoint.y = fabs(actualRadius) * sin(alpha);

        // we offset the center of the circle, to get the coordinate from the right top left origin
        returnedPoint.x = returnedPoint.x + CGRectGetMidX(_gradientContainer.frame);
        returnedPoint.y = CGRectGetMidY(_gradientContainer.frame) - returnedPoint.y;
        return returnedPoint;
    } else {
        CGPoint point = touchPoint;
        if (point.x < [self paddingDistance]) point.x = self.paddingDistance;
        if (point.x > [self paletteDiameter] - [self paddingDistance]) {
            point.x = [self paletteDiameter] - [self paddingDistance];
        }
        if (point.y < [self paddingDistance]) point.y = self.paddingDistance;
        if (point.y > [self paletteDiameter] - [self paddingDistance]) {
            point.y = [self paletteDiameter] - [self paddingDistance];
        }
        return point;
    }
}

- (RSColorPickerState *)stateForPoint:(CGPoint)point {
    RSColorPickerState * newState = [RSColorPickerState stateForPoint:point
                                                                 size:[self paletteDiameter]
                                                              padding:[self paddingDistance]];
    newState = [[newState stateBySettingAlpha:self.opacity] stateBySettingBrightness:self.brightness];
    return newState;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (_showLoupe) {
        // Lazily load loupeLayer, if user wants to display it.
		if (!_loupeLayer) {
			_loupeLayer = [BGRSLoupeLayer layer];
		}
		[_loupeLayer appearInColorPicker:self];
	} else {
        // Otherwise, byebye
        [_loupeLayer disappear];
	}

    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateStateForTouchPoint:point];

    if ([_delegate respondsToSelector:@selector(colorPicker:touchesBegan:withEvent:)]) {
        [_delegate colorPicker:self touchesBegan:touches withEvent:event];
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateStateForTouchPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateStateForTouchPoint:point];

    [_loupeLayer disappear];

    if ([_delegate respondsToSelector:@selector(colorPicker:touchesEnded:withEvent:)]) {
        [_delegate colorPicker:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_loupeLayer disappear];
}

#pragma mark - Class Methods -

static NSCache *generatedBitmaps;
static NSOperationQueue *generateQueue;
static dispatch_queue_t backgroundQueue;

+ (void)initialize {
    generatedBitmaps = [NSCache new];
    generateQueue = [NSOperationQueue new];
    generateQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    backgroundQueue = dispatch_queue_create("com.github.rsully.rscolorpicker.background", DISPATCH_QUEUE_SERIAL);
}

#pragma mark Background Methods

+ (void)prepareForDiameter:(CGFloat)diameter {
    [self prepareForDiameter:diameter padding:kSelectionViewSize/2.0];
}

+ (void)prepareForDiameter:(CGFloat)diameter padding:(CGFloat)padding {
    [self prepareForDiameter:diameter scale:1.0 padding:padding];
}

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale {
    [self prepareForDiameter:diameter scale:scale padding:kSelectionViewSize/2.0];
}

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding {
    [self prepareForDiameter:diameter scale:scale padding:padding inBackground:YES];
}

#pragma mark Prep Method

+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding inBackground:(BOOL)bg {
    void (*function)(dispatch_queue_t, dispatch_block_t) = bg ? dispatch_async : dispatch_sync;
    function(backgroundQueue, ^{
        [self bitmapForDiameter:diameter scale:scale padding:padding shouldCache:YES];
    });
}

#pragma mark Generate Helper Method

+ (ANImageBitmapRep *)bitmapForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)paddingDistance shouldCache:(BOOL)cache {
    RSGenerateOperation *repOp = nil;

    // Handle the scale here so the operation can just work with pixels directly
    paddingDistance *= scale;
    diameter *= scale;

    if (diameter <= 0) return nil;

    // Unique key for this size combo
    NSString *dictionaryCacheKey = [NSString stringWithFormat:@"%.1f-%.1f", diameter, paddingDistance];
    // Check cache
    repOp = [generatedBitmaps objectForKey:dictionaryCacheKey];

    if (repOp) {
        if (!repOp.isFinished) {
            [repOp waitUntilFinished];
        }
        return repOp.bitmap;
    }

    repOp = [[RSGenerateOperation alloc] initWithDiameter:diameter andPadding:paddingDistance];

    if (cache) {
        [generatedBitmaps setObject:repOp forKey:dictionaryCacheKey cost:diameter];
    }

    [generateQueue addOperation:repOp];
    [repOp waitUntilFinished];

    return repOp.bitmap;
}

@end
