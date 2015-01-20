//
//  DataService.m
//  ToDoList
//
//  Created by Carmen Albu on 17/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "DataService.h"
#import <PFFacebookUtils.h>
#import "Reachability.h"
#import "Defines.h"


static DataService *_instance = nil;
static BOOL _isReachable;

@implementation DataService

- (void) checkForConnection
{
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // this is called on a background thread and if you are updating the UI it needs to happenon the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            _isReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isReachable = NO;
            NSLog(@"UNREACHABLE!");
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

+ (void)saveToDoItem:(ToDoModel *)toDoModel
{
    UserModel *userModel = [UserModel currentUser];
    PFObject *toDoItem = [PFObject objectWithClassName:TODOITEMS_CLASS];
    
    if(toDoModel.objectId)
    {
        //get existing item - in order to update
        PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
        [query getObjectInBackgroundWithId:toDoModel.objectId block:^(PFObject *object, NSError *error) {
            [DataService saveItem:object withToDoModelData:toDoModel andUserModel:userModel];
        }];
    }
    else
    {
        [DataService saveItem:toDoItem withToDoModelData:toDoModel andUserModel:userModel];
    }
    //save new item
}

+ (void) deleteToDoItem:(ToDoModel*)toDoModel
{
    if(toDoModel.objectId)
    {
        //get existing item - in order to delete
        PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
        [query getObjectInBackgroundWithId:toDoModel.objectId block:^(PFObject *object, NSError *error) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [DataService updateCachedToDoItems:toDoModel.completed];
            }];
        }];
    }
}

+(void) saveItem:(PFObject*)toDoItem withToDoModelData:(ToDoModel*)toDoModel andUserModel:(UserModel*)userModel
{
    toDoItem[ITEM_TITLE] = toDoModel.itemTitle;
    toDoItem[ITEM_DESCRIPTION] = toDoModel.itemDescription;
    toDoItem[ITEM_COMPLETED] = (toDoModel.completed) ? @YES : @NO ;
    toDoItem[ITEM_USERID] = userModel.objectId;
    
    if(_isReachable)
    {
        [toDoItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [DataService updateCachedToDoItems:toDoModel.completed];
        }];
    }
    else
    {
        [toDoItem saveEventually];
    }
}

+ (void)getToDoItemsCompleted:(BOOL)completed withCompletionBlock:(void(^)(NSMutableArray *toDoItems))completionBlock
{
    UserModel *user = [UserModel currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
    [query whereKey:ITEM_COMPLETED equalTo:(completed) ? @YES : @NO];
    [query whereKey:ITEM_USERID equalTo:user.objectId];
    [query orderByDescending:ITEM_UPDATEDAT];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error == nil)
        {
            NSMutableArray *array = [NSMutableArray array];
            NSLog(@"objects found %lu",(unsigned long)objects.count);
            
            for(PFObject *object in objects)
            {
                ToDoModel *toDoModel = [[ToDoModel alloc] init];
                toDoModel.objectId = object.objectId;
                toDoModel.itemTitle = object[ITEM_TITLE];
                toDoModel.itemDescription = object[ITEM_DESCRIPTION];
                toDoModel.completed = [object[ITEM_COMPLETED] boolValue];
                
                [array addObject:toDoModel];
            }
            
            completionBlock(array);
        }
    }];
    
    //return array;
}


+ (void) updateCachedToDoItems:(BOOL)completed {
    UserModel *user = [UserModel currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
    [query whereKey:ITEM_COMPLETED equalTo:(completed) ? @YES : @NO];
    [query whereKey:ITEM_USERID equalTo:user.objectId];
    [query orderByDescending:ITEM_UPDATEDAT];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error == nil)
        {
            NSMutableArray *array = [NSMutableArray array];
            NSLog(@"objects found %lu",(unsigned long)objects.count);
            
            for(PFObject *object in objects)
            {
                ToDoModel *toDoModel = [[ToDoModel alloc] init];
                toDoModel.objectId = object.objectId;
                toDoModel.itemTitle = object[ITEM_TITLE];
                toDoModel.itemDescription = object[ITEM_DESCRIPTION];
                toDoModel.completed = [object[ITEM_COMPLETED] boolValue];
                
                [array addObject:toDoModel];
            }
        }
    }];
}



@end
