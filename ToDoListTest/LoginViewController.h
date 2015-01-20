//
//  LoginViewController.h
//  ToDoListTest
//
//  Created by Carmen Albu on 19/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginFacebookButton;


- (IBAction)action_logIn:(id)sender;
- (IBAction)action_signUp:(id)sender;
- (IBAction)action_loginWithFacebook:(id)sender;


@end
