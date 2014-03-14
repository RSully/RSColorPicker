//
//  CPTestCase.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/13/14.
//
//

#import <XCTest/XCTest.h>

@interface CPTestCase : XCTestCase

- (void)assertColor:(UIColor *)colorA equalsColor:(UIColor *)colorB;
- (void)assertColor:(UIColor *)colorA notEqualsColor:(UIColor *)colorB;

@end
