//
//  DataService.h
//  ToDoList
//
//  Created by Carmen Albu on 17/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoModel.h"
#import <Parse/Parse.h>
#import "UserModel.h"

@interface DataService : NSObject

+ (BOOL) checkForConnection;
+ (void) saveToDoItem:(ToDoModel*)toDoModel;
+ (void) deleteToDoItem:(ToDoModel*)toDoModel;
+ (void)getToDoItemsCompleted:(BOOL)completed withCompletionBlock:(void(^)(NSMutableArray *objects))completionBlock;
+ (void) saveItem:(PFObject*)toDoItem withToDoModelData:(ToDoModel*)toDoModel andUserModel:(UserModel*)userModel;
+ (void) signUp:(UserModel*)userModel withCompletionBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock;
+ (void) signIn:(UserModel*)userModel withCompletionBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock;
@end
