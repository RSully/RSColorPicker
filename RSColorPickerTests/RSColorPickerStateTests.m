//
//  RSColorPickerStateTests.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/31/14.
//
//

#import <XCTest/XCTest.h>
#import "RSColorPickerState.h"
#import "RSColorFunctions.h"

@interface RSColorPickerStateTests : CPTestCase

@end

@implementation RSColorPickerStateTests

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



- (void)testHue_initWithColor {
    for (int i = 0; i < 5; i++)
    {
        UIColor *expectedColor = RSRandomColorOpaque(i % 2 == 0);
        RSColorPickerState *state = [[RSColorPickerState alloc] initWithColor:expectedColor];

        CGFloat h, s, v, a;
        [expectedColor getHue:NULL saturation:&s brightness:&v alpha:&a];
        h = state.hue;

        UIColor *actualColor = [UIColor colorWithHue:h saturation:s brightness:v alpha:a];

        [self assertColor:actualColor equalsColor:expectedColor];
    }
}

- (void)testSaturation_initWithColor {
    for (int i = 0; i < 5; i++)
    {
        UIColor *expectedColor = RSRandomColorOpaque(i % 2 == 0);
        RSColorPickerState *state = [[RSColorPickerState alloc] initWithColor:expectedColor];

        CGFloat h, s, v, a;
        [expectedColor getHue:&h saturation:NULL brightness:&v alpha:&a];
        s = state.saturation;

        UIColor *actualColor = [UIColor colorWithHue:h saturation:s brightness:v alpha:a];

        [self assertColor:actualColor equalsColor:expectedColor];
    }
}

- (void)testColor_initWithColor {
    for (int i = 0; i < 5; i++)
    {
        UIColor *expectedColor = RSRandomColorOpaque(i % 2 == 0);
        RSColorPickerState *state = [[RSColorPickerState alloc] initWithColor:expectedColor];

        [self assertColor:state.color equalsColor:expectedColor];
    }
}


- (void)testSelectionLocationWithSizePadding {
    UIColor *expectedColor;
    RSColorPickerState *state;
    CGPoint expectedPoint, actualPoint;



    expectedColor = [UIColor blackColor];
    state = [[RSColorPickerState alloc] initWithColor:expectedColor];

    expectedPoint = CGPointMake(100, 100);
    actualPoint = [state selectionLocationWithSize:200.0 padding:20.0];

    XCTAssertEqual(expectedPoint.x, actualPoint.x);
    XCTAssertEqual(expectedPoint.y, actualPoint.y);


    expectedColor = [UIColor whiteColor];
    state = [[RSColorPickerState alloc] initWithColor:expectedColor];

    expectedPoint = CGPointMake(100, 100);
    actualPoint = [state selectionLocationWithSize:200.0 padding:20.0];

    XCTAssertEqual(expectedPoint.x, actualPoint.x);
    XCTAssertEqual(expectedPoint.y, actualPoint.y);
}

@end
