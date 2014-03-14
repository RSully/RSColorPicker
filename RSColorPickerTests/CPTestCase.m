//
//  CPTestCase.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/13/14.
//
//

#import "CPTestCase.h"
#import "RSColorFunctions.h"

#define kColorComponentAccuracy (1.0/255.0)

@implementation CPTestCase

#pragma mark - Component helpers

- (void)assertColor:(UIColor *)colorA equalsColor:(UIColor *)colorB
{
    CGFloat rgbaA[4];
    CGFloat rgbaB[4];

    RSGetComponentsForColor(rgbaA, colorA);
    RSGetComponentsForColor(rgbaB, colorB);

    XCTAssertEqualWithAccuracy(rgbaA[0], rgbaB[0], kColorComponentAccuracy);
    XCTAssertEqualWithAccuracy(rgbaA[1], rgbaB[1], kColorComponentAccuracy);
    XCTAssertEqualWithAccuracy(rgbaA[2], rgbaB[2], kColorComponentAccuracy);
    XCTAssertEqualWithAccuracy(rgbaA[3], rgbaB[3], kColorComponentAccuracy);
}
- (void)assertColor:(UIColor *)colorA notEqualsColor:(UIColor *)colorB
{
    CGFloat rgbaA[4];
    CGFloat rgbaB[4];

    RSGetComponentsForColor(rgbaA, colorA);
    RSGetComponentsForColor(rgbaB, colorB);

    XCTAssertNotEqualWithAccuracy(rgbaA[0], rgbaB[0], kColorComponentAccuracy);
    XCTAssertNotEqualWithAccuracy(rgbaA[1], rgbaB[1], kColorComponentAccuracy);
    XCTAssertNotEqualWithAccuracy(rgbaA[2], rgbaB[2], kColorComponentAccuracy);
    XCTAssertNotEqualWithAccuracy(rgbaA[3], rgbaB[3], kColorComponentAccuracy);
}

@end
