//
//  AppDelegate.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ToDoTableViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DataService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize incompletedItems;
@synthesize completedItems;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[Parse enableLocalDatastore];
    [Parse setApplicationId:@"rlE4EzugnQuvAExIWXg1nylaD8q4gda3GdPGIikr"
                  clientKey:@"sF5YTXOylZoprbcr6DmIzcP8FTIUnlAGOMCvbmGz"];
    [PFFacebookUtils initializeFacebook];
                                                                                                                                                                                                                                                                                                                                                                                                   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    self.incompletedItems = [NSMutableArray array];
    self.completedItems = [NSMutableArray array];
    
    if([PFUser currentUser])
    {
        ToDoTableViewController *toDoTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ToDoTableViewController"];
        [navigationController setViewControllers:[NSArray arrayWithObject:toDoTableViewController] animated:YES];
        self.window.rootViewController = navigationController;
    }
    else
    {
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [navigationController setViewControllers:[NSArray arrayWithObject:loginViewController] animated:YES];
        self.window.rootViewController = navigationController;
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
