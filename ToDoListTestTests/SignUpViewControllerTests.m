//
//  SignUpViewControllerTests.m
//  ToDoListTest
//
//  Created by Carmen Albu on 19/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SignUpViewController.h"
#import "UserModel.h"

static NSString *username = @"test2@test.ro";
static NSString *password = @"test2";

@interface SignUpViewController (Test)

- (void) signUpAction:(UserModel*)user;

@end

@interface SignUpViewControllerTests : XCTestCase

@property (nonatomic) SignUpViewController *signUpViewController;

@end

@implementation SignUpViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.signUpViewController = [[SignUpViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSignUpAction {
    UserModel *userModel = [[UserModel alloc] init];
    userModel.email = userModel.username = username;
    userModel.password = password;
    
    [self.signUpViewController signUpAction:userModel];
}

- (void)testPerformanceSignUpAction {
    
    [self measureBlock:^{
        UserModel *userModel = [[UserModel alloc] init];
        userModel.email = userModel.username = username;
        userModel.password = password;
        
        [self.signUpViewController signUpAction:userModel];
    }];
}

@end
