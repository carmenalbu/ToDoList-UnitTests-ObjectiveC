//
//  LoginViewController.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ToDoTableViewController.h"
#import "AppDelegate.h"
#import "GenericUtils.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)action_logIn:(id)sender {
    UserModel *user = [[UserModel alloc] init];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    user.email = user.username = email;
    user.password = password;
    
    
}

- (void) loginAction:(UserModel*)user {
    if(user.password.length > 0 && user.email.length >0)
    {
        if([GenericUtils validateEmail:user.email])
        {
            
            
            [DataService signIn:user withCompletionBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    [self goToHomescreen];
                }
                else
                {
                    NSString *errorMessage = @"An error has occurred. Try again.";
                    
                    if(error)
                    {
                        errorMessage = error.userInfo[@"error"];
                    }
                    
                    [GenericUtils showAlertViewWithTitleAndOneButton:@"Error" andMessage:errorMessage withClosure:^(NSInteger index) {
                        NSLog(@"error login");
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

- (IBAction)action_signUp:(id)sender {
    //[self performSegueWithIdentifier:@"goToSignUpViewController" sender:self];
}

- (IBAction)action_loginWithFacebook:(id)sender {
    NSArray *permissions = @[@"public_profile", @"email"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        NSLog(@"error %@",error);
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self saveFacebookData:user];
            
        } else {
            NSLog(@"User logged in through Facebook!");
            
            [self goToHomescreen];
        }
    }];
}

- (void) saveFacebookData:(PFUser *)user
{
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *facebookId = [result objectForKey:@"id"];
             NSString *name = [result objectForKey:@"name"];
             
             user[@"username"] = name;
             user[@"facebookId"] = facebookId;
             user[@"email"] = [result objectForKey:@"email"];
             
             [user saveInBackground];
             
             [self goToHomescreen];
         }
     }];
}

- (void) goToHomescreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    ToDoTableViewController *toDoTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ToDoTableViewController"];
    [navigationController setViewControllers:[NSArray arrayWithObject:toDoTableViewController] animated:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
    
    [self performSegueWithIdentifier:@"goToTableViewController" sender:self];
}

@end
