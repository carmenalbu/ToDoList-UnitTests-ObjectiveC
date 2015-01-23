//
//  SignUpViewController.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "SignUpViewController.h"
#import "DataService.h"
#import "GenericUtils.h"
#import "ToDoTableViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)action_signUp:(id)sender {
    
    UserModel *user = [[UserModel alloc] init];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    user.email = user.username = email;
    user.password = password;
    
    [self signUpAction:user];
}

- (void) signUpAction:(UserModel*)user
{
    if(user.password.length > 0 && user.email.length >0)
    {
        if([GenericUtils validateEmail:user.email])
        {
            [DataService signUp:user withCompletionBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    [self goToHomescreen];
                }
                else
                {
                    [GenericUtils showAlertViewWithTitleAndOneButton:@"Error" andMessage:@"An error has occurred. Try again." withClosure:^(NSInteger index) {
                        NSLog(@"error sign up");
                    }];
                }
            }];
        }
        else
        {
            [GenericUtils showAlertViewWithTitleAndOneButton:@"Attention" andMessage:@"Invalid email address." withClosure:^(NSInteger index) {
                NSLog(@"invalid email address");
            }];
        }
    }
    else
    {
        [GenericUtils showAlertViewWithTitleAndOneButton:@"Attention" andMessage:@"All fields are mandatory." withClosure:^(NSInteger index) {
            NSLog(@"closure");
        }];
    }
}

- (void) goToHomescreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    ToDoTableViewController *toDoTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ToDoTableViewController"];
    [navigationController setViewControllers:[NSArray arrayWithObject:toDoTableViewController] animated:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
    
    [self performSegueWithIdentifier:@"showTableViewFromSignUp" sender:self];
}

@end
