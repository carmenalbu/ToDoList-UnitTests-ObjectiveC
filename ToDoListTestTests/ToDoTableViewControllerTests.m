//
//  ToDoTableViewControllerTests.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ToDoTableViewController.h"


@interface ToDoTableViewController (Test)

- (void) getData;
- (void) refreshData:(id)sender;
- (void) updateCellAtIndexPath;
- (void) logout;

@end

@interface ToDoTableViewControllerTests : XCTestCase

@property (nonatomic) ToDoTableViewController *toDoTableViewController;

@end

@implementation ToDoTableViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.toDoTableViewController = [[ToDoTableViewController alloc] init];
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

- (void) testGetData {
    [self.toDoTableViewController getData];
}

- (void) testPerformanceGetData {
    [self measureBlock:^{
        [self.toDoTableViewController getData];
    }];
}

- (void) testRefreshData {
    [self.toDoTableViewController refreshData:nil];
}

- (void) testPerformanceRefreshData {
    [self measureBlock:^{
        [self.toDoTableViewController refreshData:nil];
    }];
}

- (void) testUpdateCellAtIndexPath {
    [self.toDoTableViewController updateCellAtIndexPath];
}

- (void) testPerformanceUpdateCellAtIndexPath {
    [self measureBlock:^{
        [self.toDoTableViewController updateCellAtIndexPath];
    }];
}

- (void) testLogOut {
    [self.toDoTableViewController logout];
}

- (void) testPerformanceLogout {
    [self measureBlock:^{
        [self.toDoTableViewController logout];
    }];
}

- (void) testViewDidLoad {
    [self.toDoTableViewController viewDidLoad];
}

- (void) testPerformanceViewDidLoad {
    [self.toDoTableViewController viewDidLoad];
}

@end
