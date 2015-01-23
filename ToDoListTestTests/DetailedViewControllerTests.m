//
//  DetailedViewControllerTests.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DetailedViewController.h"
#import "ToDoModel.h"

@interface DetailedViewController (Test)

- (void) initSetup;
- (void) saveItem;

@end

@interface DetailedViewControllerTests : XCTestCase

@property (nonatomic) DetailedViewController *detailedViewController;
@property (nonatomic) ToDoModel *toDoModel;

@end

@implementation DetailedViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.detailedViewController = [[DetailedViewController alloc] init];
    
    self.toDoModel = [[ToDoModel alloc] init];
    self.toDoModel.itemTitle = @"Title";
    self.toDoModel.itemDescription = @"Description";
    self.toDoModel.completed = NO;
    
    self.detailedViewController.toDoModel = self.toDoModel;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testInitSetup {
    [self.detailedViewController initSetup];
}

- (void) testPerformanceInitSetup {
    [self measureBlock:^{
        [self.detailedViewController initSetup];
    }];
}

- (void) testViewDidLoad {
    [self.detailedViewController viewDidLoad];
}

- (void) testSaveItem {
    [self.detailedViewController saveItem];
}

- (void) testPerformanceSaveItem {
    [self measureBlock:^{
        [self.detailedViewController saveItem];
    }];
}

- (void) testActionCompleteBarItem {
    [self.detailedViewController action_completeBarItem:nil];
}

- (void) testPerformanceActionCompleteBarItem {
    [self measureBlock:^{
        [self.detailedViewController action_completeBarItem:nil];
    }];
}

@end
