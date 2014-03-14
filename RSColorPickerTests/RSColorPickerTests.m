//
//  RSColorPickerTests.m
//  RSColorPickerTests
//
//  Created by Ryan Sullivan on 3/13/14.
//
//

#import <XCTest/XCTest.h>
#import "CPTestCase.h"
#import "RSColorPickerView.h"
#import "RSColorFunctions.h"


@interface RSColorPickerTests : CPTestCase <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView * colorPicker;
@property (nonatomic) int delegateDidChangeSelectionCalledCount;

@end


@implementation RSColorPickerTests

- (void)setUp
{
    [super setUp];

    // Reset counter
    self.delegateDidChangeSelectionCalledCount = 0;

    self.colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    self.colorPicker.selectionColor = RSRandomColorOpaque(NO);
    // Make sure we set delegate last so counters don't get messed up by init
    self.colorPicker.delegate = self;
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

    [self assertColor:currentSelection notEqualsColor:oldSelection];
    [self assertColor:currentSelection equalsColor:newSelection];
}

- (void)testSetSelectionColor_self
{
    UIColor *currentColor = self.colorPicker.selectionColor;
    self.colorPicker.selectionColor = currentColor;

    XCTAssertEqualObjects(currentColor, self.colorPicker.selectionColor);
}


- (void)testSetCropToCircle
{
    // TODO: better testing here
    self.colorPicker.cropToCircle = YES;
    XCTAssert(self.colorPicker.cropToCircle == YES, @"Crop to circle failed");
}


- (void)testDelegateDidChangeSelection
{
    self.colorPicker.selectionColor = RSRandomColorOpaque(NO);
    XCTAssertEqual(self.delegateDidChangeSelectionCalledCount, 1);
}


- (void)testSetSelection
{
    // TODO
}

- (void)testSetShowLoupe
{
    // TODO: how would you even test this?
}

- (void)testColorAtPoint
{
    // TODO
}

// TODO: test prepare methods

#pragma mark - RSColorPickerView Delegates

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
    self.delegateDidChangeSelectionCalledCount++;
    NSLog(@"Got RSColorPickerViewDelegate selection change callback");
}
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    XCTFail(@"Got -touchesBegan from running tests");
}
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    XCTFail(@"Got -touchesBegan from running tests");
}


@end
