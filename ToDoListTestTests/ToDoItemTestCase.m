//
//  ToDoItemTestCase.m
//  ToDoListTest
//
//  Created by Carmen Albu on 20/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "ToDoModel.h"
#import "Defines.h"

static NSString* defaultUserId = @"3fzhGgkn2t";

@interface ToDoItemTestCase : XCTestCase

@property (nonatomic, retain) ToDoModel* toDoModel;
@property (nonatomic, retain) ToDoModel* deleteToDoModel;
@property (nonatomic, retain) ToDoModel* updateToDoModel;

@end

@implementation ToDoItemTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testCreatingToDoItem {
    self.toDoModel.itemTitle = @"test title";
    self.toDoModel.itemDescription = @"test description";
}

- (void) testGettingAllCompletedItemsFromUser {
    //grab all completed items
    
    [Parse setApplicationId:@"rlE4EzugnQuvAExIWXg1nylaD8q4gda3GdPGIikr"
                  clientKey:@"sF5YTXOylZoprbcr6DmIzcP8FTIUnlAGOMCvbmGz"];
    
    [self measureBlock:^{
        PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
        [query whereKey:ITEM_COMPLETED equalTo:@YES];
        [query whereKey:ITEM_USERID equalTo:defaultUserId];
        [query orderByDescending:ITEM_UPDATEDAT];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error == nil)
            {
                NSLog(@"objects found %lu",(unsigned long)objects.count);
                
                for(PFObject *object in objects)
                {
                    ToDoModel *toDoModel = [[ToDoModel alloc] init];
                    toDoModel.objectId = object.objectId;
                    toDoModel.itemTitle = object[ITEM_TITLE];
                    toDoModel.itemDescription = object[ITEM_DESCRIPTION];
                    toDoModel.completed = [object[ITEM_COMPLETED] boolValue];
                    
                }
                
            }
        }];
    }];
}

- (void) testGettingAllIncompletedItemsFromUser {
    //grab all completed items
    
    [self measureBlock:^{
        PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
        [query whereKey:ITEM_COMPLETED equalTo:@NO];
        [query whereKey:ITEM_USERID equalTo:defaultUserId];
        [query orderByDescending:ITEM_UPDATEDAT];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error == nil)
            {
                NSLog(@"objects found %lu",(unsigned long)objects.count);
                
                for(PFObject *object in objects)
                {
                    ToDoModel *toDoModel = [[ToDoModel alloc] init];
                    toDoModel.objectId = object.objectId;
                    toDoModel.itemTitle = object[ITEM_TITLE];
                    toDoModel.itemDescription = object[ITEM_DESCRIPTION];
                    toDoModel.completed = [object[ITEM_COMPLETED] boolValue];
                    
                    if(self.deleteToDoModel == nil)
                    {
                        self.deleteToDoModel = toDoModel;
                    }
                    else if(self.updateToDoModel == nil)
                    {
                        self.updateToDoModel = toDoModel;
                    }
                }
                
            }
        }];
    }];
}

- (void) testSavingToDoItem {
    [self measureBlock:^{
        PFObject *toDoItem = [PFObject objectWithClassName:TODOITEMS_CLASS];
        
        toDoItem[ITEM_TITLE] = @"test";
        toDoItem[ITEM_DESCRIPTION] = @"test description";
        toDoItem[ITEM_COMPLETED] = @NO ;
        toDoItem[ITEM_USERID] = defaultUserId;
        
        [toDoItem saveInBackground];
        
    }];
}

- (void) testUpdatingExistingToDoItem {
    [self measureBlock:^{
        if(self.updateToDoModel.objectId)
        {
            //get existing item - in order to update
            PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
            [query getObjectInBackgroundWithId:self.updateToDoModel.objectId block:^(PFObject *object, NSError *error) {
                object[ITEM_TITLE] = self.updateToDoModel.itemTitle;
                object[ITEM_DESCRIPTION] = self.updateToDoModel.itemDescription;
                object[ITEM_COMPLETED] = (self.updateToDoModel.completed) ? @YES : @NO ;
                object[ITEM_USERID] = defaultUserId;
            }];
        }
    }];
}

- (void) testDeletingToDoItem {
    [self measureBlock:^{
        if(self.deleteToDoModel.objectId)
        {
            //get existing item - in order to delete
            PFQuery *query = [PFQuery queryWithClassName:TODOITEMS_CLASS];
            [query getObjectInBackgroundWithId:self.deleteToDoModel.objectId block:^(PFObject *object, NSError *error) {
                [object deleteInBackground];
            }];
        }
        
    }];
}

@end
