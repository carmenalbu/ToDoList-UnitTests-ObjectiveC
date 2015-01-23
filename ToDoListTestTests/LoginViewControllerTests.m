//
//  LoginViewControllerTests.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import "UserModel.h"

static NSString *username = @"test@test.ro";
static NSString *password = @"test";

@interface LoginViewController (Test)

- (void) loginAction:(UserModel*)user;

@end

@interface LoginViewControllerTests : XCTestCase

@property (nonatomic) LoginViewController *loginViewController;

@end

@implementation LoginViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.loginViewController = [[LoginViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginAction {
    UserModel *userModel = [[UserModel alloc] init];
    userModel.email = userModel.username = username;
    userModel.password = password;
    
    [self.loginViewController loginAction:userModel];
}

- (void)testPerformanceLoginAction {
    
    [self measureBlock:^{
        UserModel *userModel = [[UserModel alloc] init];
        userModel.email = userModel.username = username;
        userModel.password = password;
        
        [self.loginViewController loginAction:userModel];
    }];
}



@end
