//
//  LoginViewController.m
//  ToDoListTest
//
//  Created by Carmen Albu on 19/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ToDoTableViewController.h"
#import "AppDelegate.h"

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

}

- (IBAction)action_signUp:(id)sender {

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
