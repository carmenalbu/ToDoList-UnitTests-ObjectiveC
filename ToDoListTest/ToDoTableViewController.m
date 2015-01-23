//
//  ToDoTableViewController.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "LoginViewController.h"
#import "DetailedViewController.h"
#import "Defines.h"
#import "ToDoModel.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppDelegate.h"

#define REUSE_IDENTIFIER @"ToDoCell"
#define TAG_LOGOUT_ALERTVIEW 1

@interface ToDoTableViewController () {

    //NSMutableArray *_completeItems;
    //NSMutableArray *_incompleteItems;
    AppDelegate *appDelegate;
}

@end

@implementation ToDoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.navigationController.navigationBarHidden = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:@"toDoItemModified"
                                               object:nil];
    
    [self getData];
    
}

- (void) getData {
    
    // YES - for completed Items, NO - for incompleted Items
    [DataService getToDoItemsCompleted:NO withCompletionBlock:^(NSMutableArray *objects) {
        //_incompleteItems = objects;
        appDelegate.incompletedItems = objects;
        [self.tableView reloadData];
    }];
    
    [DataService getToDoItemsCompleted:YES withCompletionBlock:^(NSMutableArray *objects) {
        //_completeItems = objects;
        appDelegate.completedItems = objects;
        [self.tableView reloadData];
    }];
    
}

- (void) refreshData:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //2 sections: 0 - Incomplete items, 1 - completeItems
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 0 == incomplete, 1 == complete
    if(section == 0)
    {
        return appDelegate.incompletedItems.count;
    }
    
    return appDelegate.completedItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    
    ToDoModel *toDoModel;
    
    if(indexPath.section == 0)
    {
        toDoModel = [appDelegate.incompletedItems objectAtIndex:indexPath.row];
        
        cell.tintColor = cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor blackColor];
        
    }
    else if (indexPath.section == 1)
    {
        toDoModel = [appDelegate.completedItems objectAtIndex:indexPath.row];
        
        cell.tintColor = cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = toDoModel.itemTitle;
    cell.detailTextLabel.text = toDoModel.itemDescription;
    
    if(toDoModel.completed)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    
    for(UIGestureRecognizer * gestureRecognizer in cell.gestureRecognizers)
    {
        if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            [cell removeGestureRecognizer:gestureRecognizer];
        }
    }
    
    [cell addGestureRecognizer:longPressGestureRecognizer];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"To Do";
            break;
        case 1:
            sectionName = @"Completed";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoModel *toDoModel;
        if(indexPath.section == 0)
        {
            toDoModel = [appDelegate.incompletedItems objectAtIndex:indexPath.row];
            
            [appDelegate.incompletedItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if(indexPath.section == 1)
        {
            toDoModel = [appDelegate.completedItems objectAtIndex:indexPath.row];
            
            [appDelegate.completedItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [DataService deleteToDoItem:toDoModel];
    }
}

- (void) updateCellAtIndexPath
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath)
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) longPressCell:(UILongPressGestureRecognizer*) gestureRecognizer
{
    UITableViewCell *cell = (UITableViewCell*)gestureRecognizer.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ToDoModel *toDoModel;
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if(indexPath.section == 0)
        {
            toDoModel = [appDelegate.incompletedItems objectAtIndex:indexPath.row];
            toDoModel.completed = YES;
            
            [appDelegate.incompletedItems removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [appDelegate.completedItems insertObject:toDoModel atIndex:0];
        }
        else if(indexPath.section == 1)
        {
            toDoModel = [appDelegate.completedItems objectAtIndex:indexPath.row];
            toDoModel.completed = NO;
            
            [appDelegate.completedItems removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [appDelegate.incompletedItems insertObject:toDoModel atIndex:0];
        }
        
        [DataService saveToDoItem:toDoModel];
        
        [self.tableView reloadData];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == TAG_LOGOUT_ALERTVIEW)
    {
        if(buttonIndex == 1)
        {
            [self logout];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailedViewController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToDoModel *toDoModel;
        
        if(indexPath.section == 0)
        {
            toDoModel = [appDelegate.incompletedItems objectAtIndex:indexPath.row];
        }
        if(indexPath.section == 1)
        {
            toDoModel = [appDelegate.completedItems objectAtIndex:indexPath.row];
        }
    
        [(DetailedViewController*)[segue destinationViewController] setToDoModel:toDoModel];
        [(DetailedViewController*)[segue destinationViewController] setIndexPath:indexPath];
    }
}

- (IBAction)action_logOut:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logging out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
    alertView.tag = TAG_LOGOUT_ALERTVIEW;
    
    [alertView show];
}

- (void) logout
{
    [PFUser logOut];
    
    [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL Success,NSError *unlinkError){
        if(!unlinkError){
            // User unlinked
        }else{
            // Erro while unlink user
        }
    }];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    [[PFFacebookUtils session] close];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [navigationController setViewControllers:[NSArray arrayWithObject:loginViewController] animated:YES];
    appDelegate.window.rootViewController = navigationController;
    
    //[self performSegueWithIdentifier:@"showLoginViewController" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
