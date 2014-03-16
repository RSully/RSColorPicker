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

- (void)testComponentsForColor {

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
