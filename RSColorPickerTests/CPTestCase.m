//
//  CPTestCase.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/13/14.
//
//

#import "CPTestCase.h"
#import "RSColorFunctions.h"


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

    // Check it manually too
    // Might as well keep this code around if we're maintaining the one below
    XCTAssert(
        (fabs(rgbaA[0] - rgbaB[0]) < kColorComponentAccuracy) &&
        (fabs(rgbaA[1] - rgbaB[1]) < kColorComponentAccuracy) &&
        (fabs(rgbaA[2] - rgbaB[2]) < kColorComponentAccuracy) &&
        (fabs(rgbaA[3] - rgbaB[3]) < kColorComponentAccuracy),
        @"Color %@ does not equal color %@, but they should be equal", colorA, colorB
    );
}
- (void)assertColor:(UIColor *)colorA notEqualsColor:(UIColor *)colorB
{
    CGFloat rgbaA[4];
    CGFloat rgbaB[4];

    RSGetComponentsForColor(rgbaA, colorA);
    RSGetComponentsForColor(rgbaB, colorB);

    XCTAssert(
        (fabs(rgbaA[0] - rgbaB[0]) > kColorComponentAccuracy) ||
        (fabs(rgbaA[1] - rgbaB[1]) > kColorComponentAccuracy) ||
        (fabs(rgbaA[2] - rgbaB[2]) > kColorComponentAccuracy) ||
        (fabs(rgbaA[3] - rgbaB[3]) > kColorComponentAccuracy),
        @"Color %@ is too similar to %@, but they should not be equal", colorA, colorB
    );
}

@end
