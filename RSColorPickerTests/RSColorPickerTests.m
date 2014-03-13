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

    XCTAssertEqualObjects(newSelection, setA);
    XCTAssertEqualObjects(newSelection, setB);

    XCTAssertEqualObjects(setA, setB);
}

- (void)testSetSelectionColor_random
{
    UIColor *newSelection = RSRandomColorOpaque(NO);
    UIColor *oldSelection = self.colorPicker.selectionColor;

    self.colorPicker.selectionColor = newSelection;

    UIColor *currentSelection = self.colorPicker.selectionColor;

    XCTAssertNotEqualObjects(currentSelection, oldSelection);
    XCTAssertEqualObjects(currentSelection, newSelection);
}

- (void)testSetSelectionColor_self
{
    UIColor *currentColor = self.colorPicker.selectionColor;
    self.colorPicker.selectionColor = currentColor;

    XCTAssertEqualObjects(currentColor, self.colorPicker.selectionColor);
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
