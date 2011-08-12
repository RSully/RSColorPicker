//
//  CGImageContainer.m
//  ImageBitmapRep
//
//  Created by Alex Nichol on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CGImageContainer.h"


@implementation CGImageContainer

@synthesize image;

- (id)initWithImage:(CGImageRef)anImage {
	if ((self = [super init])) {
		image = CGImageRetain(anImage);
	}
	return self;
}

+ (CGImageContainer *)imageContainerWithImage:(CGImageRef)anImage {
	CGImageContainer * container = [(CGImageContainer *)[CGImageContainer alloc] initWithImage:anImage];
	return [container autorelease];
}

- (void)dealloc {
	CGImageRelease(image);
	[super dealloc];
}

@end
