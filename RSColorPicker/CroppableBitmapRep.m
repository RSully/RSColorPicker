//
//  CroppableBitmapRep.m
//  ImageManip
//
//  Created by Alex Nichol on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CroppableBitmapRep.h"


@implementation CroppableBitmapRep

- (void)cropFrame:(CGRect)frame {
	BMPoint size = [self bitmapSize];
	// It's kind of rude to prevent them from doing something kind of cool, so let's not.
	// NSAssert(frame.origin.x >= 0 && frame.origin.x + frame.size.width <= size.x, @"Cropping frame must be within the bitmap.");
	// NSAssert(frame.origin.y >= 0 && frame.origin.y + frame.size.height <= size.y, @"Cropping frame must be within the bitmap.");
	
	CGContextRef newBitmap = [CGContextCreator newARGBBitmapContextWithSize:frame.size];
	CGPoint offset = CGPointMake(-frame.origin.x, -frame.origin.y);
	CGContextDrawImage(newBitmap, CGRectMake(offset.x, offset.y, size.x, size.y), [self CGImage]);
	[self setContext:newBitmap];
	CGContextRelease(newBitmap);
}

- (CGImageRef)croppedImageWithFrame:(CGRect)frame {
	BMPoint size = [self bitmapSize];
	// It's kind of rude to prevent them from doing something kind of cool, so let's not.
	// NSAssert(frame.origin.x >= 0 && frame.origin.x + frame.size.width <= size.x, @"Cropping frame must be within the bitmap.");
	// NSAssert(frame.origin.y >= 0 && frame.origin.y + frame.size.height <= size.y, @"Cropping frame must be within the bitmap.");
	
	CGContextRef newBitmap = [CGContextCreator newARGBBitmapContextWithSize:frame.size];
	CGPoint offset = CGPointMake(-frame.origin.x, -frame.origin.y);
	CGContextDrawImage(newBitmap, CGRectMake(offset.x, offset.y, size.x, size.y), [self CGImage]);
	CGImageRef image = CGBitmapContextCreateImage(newBitmap);
	CGContextRelease(newBitmap);
	CGImageContainer * container = [CGImageContainer imageContainerWithImage:image];
	CGImageRelease(image);
	return [container image];
}

@end
