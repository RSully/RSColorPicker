//
//  RSColorPickerViewDelegateTests.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/15/14.
//
//

#import <XCTest/XCTest.h>

#import "RSColorPickerView.h"
#import "RSColorFunctions.h"

@interface RSColorPickerViewDelegateTests : CPTestCase <RSColorPickerViewDelegate>

@property (nonatomic) RSColorPickerView * colorPicker;
@property (nonatomic) int delegateDidChangeSelectionCalledCount;

@end

@implementation RSColorPickerViewDelegateTests

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


- (void)testDelegateDidChangeSelection_selectionColor
{
    self.colorPicker.selectionColor = RSRandomColorOpaque(NO);
    XCTAssertEqual(self.delegateDidChangeSelectionCalledCount, 1);
}
- (void)testDelegateDidChangeSelection_selection
{
    self.colorPicker.selection = CGPointMake(100.0, 100.0);
    XCTAssertEqual(self.delegateDidChangeSelectionCalledCount, 1);
}


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
    XCTFail(@"Got -touchesEnded from running tests");
}

@end

