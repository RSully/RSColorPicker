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


@class RSColorPickerView;
@protocol RSColorPickerViewDelegate <NSObject>
-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp;
@end

@interface RSColorPickerView : UIView {
    ANImageBitmapRep *rep;
    CGFloat brightness;
    
    UIView *selectionView;
    CGPoint selection;
    BOOL badTouch;
    
    id<RSColorPickerViewDelegate> delegate;
}

-(UIColor*)selectionColor;
-(CGPoint)selection;

@property (nonatomic, assign) CGFloat brightness;
@property (assign) id<RSColorPickerViewDelegate> delegate;

@end
