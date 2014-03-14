//
//  RSColorPickerTests.m
//  RSColorPickerTests
//
//  Created by Ryan Sullivan on 3/13/14.
//
//

#import <XCTest/XCTest.h>
#import "RSColorPickerView.h"
#import "RSColorFunctions.h"

#define kColorComponentAccuracy (1.0/255.0)

@interface RSColorPickerTests : XCTestCase <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView *colorPicker;

@end

@implementation RSColorPickerTests

- (void)setUp
{
    [super setUp];
    self.colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    self.colorPicker.delegate = self;
    self.colorPicker.selectionColor = RSRandomColorOpaque(NO);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetSelectionColor_multiple
{
    UIColor *newSelection = RSRandomColorOpaque(NO);

    self.colorPicker.selectionColor = newSelection;
    UIColor *setA = self.colorPicker.selectionColor;

    self.colorPicker.selectionColor = newSelection;
    UIColor *setB = self.colorPicker.selectionColor;

//    XCTAssertEqualObjects(newSelection, setA);
//    XCTAssertEqualObjects(newSelection, setB);
    [self assertColor:newSelection equalsColor:setA];
    [self assertColor:newSelection equalsColor:setB];

    XCTAssertEqualObjects(setA, setB);
}

- (void)testSetSelectionColor_random
{
    UIColor *newSelection = RSRandomColorOpaque(NO);
    UIColor *oldSelection = self.colorPicker.selectionColor;

    self.colorPicker.selectionColor = newSelection;

    UIColor *currentSelection = self.colorPicker.selectionColor;

//    XCTAssertNotEqualObjects(currentSelection, oldSelection);
//    XCTAssertEqualObjects(currentSelection, newSelection);
    [self assertColor:currentSelection notEqualsColor:oldSelection];
    [self assertColor:currentSelection equalsColor:newSelection];
}

- (void)testSetSelectionColor_self
{
    UIColor *currentColor = self.colorPicker.selectionColor;
    self.colorPicker.selectionColor = currentColor;

    XCTAssertEqualObjects(currentColor, self.colorPicker.selectionColor);
}

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

#pragma mark - RSColorPickerView Delegates

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{

}
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}


@end
