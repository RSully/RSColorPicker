//
//  RSColorFunctionsTests.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/16/14.
//
//

#import <XCTest/XCTest.h>
#import "RSColorFunctions.h"

@interface RSColorFunctionsTests : CPTestCase

@end

@implementation RSColorFunctionsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testPixelFromHSV {

}

- (void)testHSVFromPixel {

}

- (void)testComponentsForColor_rgb {
    UIColor *color = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4];
    UIColor *testColor;

    CGFloat components[4];
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    [self assertColor:color equalsColor:testColor];
}
- (void)testComponentsForColor_mono {
    UIColor *color = [UIColor colorWithWhite:0.1 alpha:0.2];
    UIColor *testColor;

    CGFloat components[4];
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    [self assertColor:color equalsColor:testColor];
}
- (void)testComponentsForColor_idk {

}

- (void)testImageWithScale {

}

- (void)testOpacityBackgroundImage {

}

- (void)testRandomColor {
    CGFloat components[4];

    UIColor *color = RSRandomColorOpaque(YES);

    RSGetComponentsForColor(components, color);
    XCTAssertEqualWithAccuracy(components[3], 1.0, kColorComponentAccuracy);
}

@end
