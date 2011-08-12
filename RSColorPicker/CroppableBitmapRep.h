//
//  CroppableBitmapRep.h
//  ImageManip
//
//  Created by Alex Nichol on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScalableBitmapRep.h"

@interface CroppableBitmapRep : ScalableBitmapRep {
    
}

/**
 * Cuts a part of the bitmap out for a new bitmap.
 * @param frame The rectangle from which a portion of the image will
 * be cut.  If this is the size of the image bitmap, the bitmap will.
 * The coordinates for this start at (0,0).
 * remain unchanged.
 */
- (void)cropFrame:(CGRect)frame;

/**
 * Creates a new CGImageRef by cutting out a portion of this one.
 * @return An autoreleased CGImageRef that has been cropped from this
 * image.
 */
- (CGImageRef)croppedImageWithFrame:(CGRect)frame;

@end
