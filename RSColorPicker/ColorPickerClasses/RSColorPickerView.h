//
//  RSColorPickerView.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//  Copyright 2011 Freelance Web Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ANImageBitmapRep.h"


@class RSColorPickerView, BGRSLoupeLayer;
@protocol RSColorPickerViewDelegate <NSObject>
-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp;
@end

@interface RSColorPickerView : UIView {
	ANImageBitmapRep *rep;
	CGFloat brightness;
	BOOL cropToCircle;
	
	UIView *selectionView;
    BGRSLoupeLayer* loupeLayer;
	CGPoint selection;
	
	BOOL badTouch;
	BOOL bitmapNeedsUpdate;
	
	id<RSColorPickerViewDelegate> delegate;
}

-(UIColor*)selectionColor;
-(CGPoint)selection;
-(void)setSelectionColor:(UIColor *)selectionColor;

@property (nonatomic, assign) BOOL cropToCircle;
@property (nonatomic, assign) CGFloat brightness;
@property (assign) id<RSColorPickerViewDelegate> delegate;

/**
 * Hue, saturation and briteness of the selected point
 * @Reference: Taken From ars/uicolor-utilities 
 * http://github.com/ars/uicolor-utilities
 */

-(void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;
-(UIColor*)colorAtPoint:(CGPoint)point; //Returns UIColor at a point in the RSColorPickerView

@end
