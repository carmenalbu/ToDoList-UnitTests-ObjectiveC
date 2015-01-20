//
//  UserModel.m
//  ToDoList
//
//  Created by Carmen Albu on 17/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "UserModel.h"

static UserModel *_userModel = nil;

@implementation UserModel

+ (UserModel*) currentUser
{
    if(_userModel == nil)
    {
        _userModel = [[UserModel alloc] init];
    }
    
    PFUser *user = [PFUser currentUser];
    
    if(user)
    {
        _userModel.objectId = user.objectId;
        _userModel.email = user.email;
        _userModel.username = user.username;
    }
    
    return _userModel;
}

@end
