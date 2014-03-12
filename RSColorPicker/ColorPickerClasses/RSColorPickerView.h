//
//  RSColorPickerView.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@class RSColorPickerView, BGRSLoupeLayer;

@protocol RSColorPickerViewDelegate <NSObject>
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp;
@optional
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface RSColorPickerView : UIView

@property (nonatomic) BOOL cropToCircle;

/**
 * Changes the brightness of the current selection
 */
@property (nonatomic) CGFloat brightness;

/**
 * Changes the opacity of the current selection.
 */
@property (nonatomic) CGFloat opacity;

/**
 * Changes the selection color. This may modify `brightness` and
 * `opacity` as necessary.
 */
@property (nonatomic) UIColor * selectionColor;

@property (nonatomic, weak) id <RSColorPickerViewDelegate> delegate;

/**
 * Get or set the current point (in the color picker's coordinates)
 * of the selected color.
 */
@property (readwrite) CGPoint selection;

/**
 * Show or hide the loupe.
 * Default: YES (show).
 */
@property (nonatomic) BOOL showLoupe;

- (UIColor *)colorAtPoint:(CGPoint)point; // Returns UIColor at a point in the RSColorPickerView

+ (void)prepareForDiameter:(CGFloat)diameter;
+ (void)prepareForDiameter:(CGFloat)diameter padding:(CGFloat)padding;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding inBackground:(BOOL)bg;
@end
