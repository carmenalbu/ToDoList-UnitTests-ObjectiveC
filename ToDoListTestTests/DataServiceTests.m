//
//  DataServiceTests.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DataService.h"
#import "ToDoModel.h"
#import "UserModel.h"

static NSString *username = @"t1est@test.ro";
static NSString *password = @"t1est";

@interface DataServiceTests : XCTestCase

@property (nonatomic) ToDoModel *toDoModel;

@end

@implementation DataServiceTests

- (void)setUp {
    [super setUp];
    
    self.toDoModel = [[ToDoModel alloc] init];
    self.toDoModel.itemTitle = @"Title";
    self.toDoModel.itemDescription = @"Description";
    self.toDoModel.completed = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testCheckForConnection {
    [DataService checkForConnection];
}

- (void) testPerformanceCheckForConnection {
    [self measureBlock:^{
        [DataService checkForConnection];
    }];
}

- (void) testSaveToDoItem {
    [DataService saveToDoItem:self.toDoModel];
}

- (void) testPerformanceSaveToDoItem {
    [self measureBlock:^{
        [DataService saveToDoItem:self.toDoModel];
    }];
}

- (void) testDeleteToDoItem {
    [DataService deleteToDoItem:self.toDoModel];
}

- (void) testPerformanceDeleteToDoItem {
    [self measureBlock:^{
        [DataService deleteToDoItem:self.toDoModel];
    }];
}

- (void) testGetToDoItemsCompleted
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Asynchronous method - get all Data"];
    
    [DataService getToDoItemsCompleted:YES withCompletionBlock:^(NSMutableArray *objects) {
        XCTAssertNotNil(objects);
        [completionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}

- (void) testSignUp
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Asynchronous method - sign up"];
    
    UserModel* userModel = [[UserModel alloc] init];
    userModel.email = userModel.username = username;
    userModel.password = password;
    
    [DataService signUp:userModel withCompletionBlock:^(BOOL succeeded, NSError *error) {
        XCTAssertTrue(succeeded);
        XCTAssertNil(error);
        [completionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}

- (void) testSignIn
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Asynchronous method - sign in"];
    
    
    UserModel* userModel = [[UserModel alloc] init];
    userModel.email = userModel.username = username;
    userModel.password = password;
    
    [DataService signIn:userModel withCompletionBlock:^(BOOL succeeded, NSError *error) {
        XCTAssertTrue(succeeded);
        XCTAssertNil(error);
        [completionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}

@end
