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
    UIColor *actual, *expected;

    // Inefficient, but should be OK:

    for (CGFloat h = 0; h < 1; h += 0.05)
    {
        for (CGFloat s = 0; s < 1; s += 0.05)
        {
            for (CGFloat v = 0; v < 0; v += 0.05)
            {
                actual = UIColorFromBMPixel(RSPixelFromHSV(h, s, v));
                expected = [UIColor colorWithHue:h saturation:s brightness:v alpha:1.0];
                [self assertColor:actual equalsColor:expected];
            }
        }
    }
}

- (void)testHSVFromPixel {
    // Not really needed yet, since we're using Apple's implementation

    BMPixel pixel = BMPixelMake(0, 0, 0, 1.0);
    CGFloat h, s, v;

    RSHSVFromPixel(pixel, &h, &s, &v);

    UIColor *color1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithHue:h saturation:s brightness:v alpha:1.0];
    [self assertColor:color1 equalsColor:color2];
}

- (void)testComponentsForColor_rgb {
    UIColor *color = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4];
    UIColor *testColor;

    CGFloat components[4];
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    [self assertColor:color equalsColor:testColor];
}
- (void)testComponentsForColor_gray {
    UIColor *color = [UIColor colorWithWhite:0.1 alpha:0.2];
    UIColor *testColor;

    CGFloat components[4];
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    [self assertColor:color equalsColor:testColor];
}
- (void)testComponentsForColor_hsv {
    UIColor *color = [UIColor colorWithHue:0 saturation:1.0 brightness:1.0 alpha:0.4];
    UIColor *testColor;

    CGFloat components[4];
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.4];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    [self assertColor:color equalsColor:testColor];
}
- (void)testComponentsForColor_cmyk {
    // All of this just to get a CMYK color
    UIColor * (^colorFromCMYK)(CGFloat C, CGFloat M, CGFloat Y, CGFloat K, CGFloat A) = ^UIColor*(CGFloat C, CGFloat M, CGFloat Y, CGFloat K, CGFloat A){
        CGColorSpaceRef cmykColorSpace = CGColorSpaceCreateDeviceCMYK();
        CGFloat colors[5] = {C, M, Y, K, A}; // CMYK+Alpha
        CGColorRef cgColor = CGColorCreate(cmykColorSpace, colors);
        UIColor *color = [UIColor colorWithCGColor:cgColor];
        CGColorRelease(cgColor);
        CGColorSpaceRelease(cmykColorSpace);
        return color;
    };


    UIColor *color;
    UIColor *testColor;
    CGFloat components[4];


    // Test all 1 (black + black)
    color = colorFromCMYK(1, 1, 1, 1, 0.5);
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self assertColor:color equalsColor:testColor];


    // Test all 0 with 1 (black)
    color = colorFromCMYK(0, 0, 0, 1, 0.5);
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self assertColor:color equalsColor:testColor];


    // Test all 0 (white)
    color = colorFromCMYK(0, 0, 0, 0, 0.5);
    RSGetComponentsForColor(components, color);

    testColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self assertColor:color equalsColor:testColor];

    testColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self assertColor:color equalsColor:testColor];
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
