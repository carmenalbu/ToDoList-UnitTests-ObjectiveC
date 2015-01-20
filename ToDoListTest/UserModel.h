//
//  UserModel.h
//  ToDoList
//
//  Created by Carmen Albu on 17/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;

+ (UserModel*) currentUser;

@end
