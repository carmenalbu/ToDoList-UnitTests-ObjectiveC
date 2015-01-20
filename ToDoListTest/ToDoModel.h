//
//  ToDoModel.h
//  ToDoList
//
//  Created by Carmen Albu on 17/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoModel : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSDate *itemDate;
@property (nonatomic) BOOL completed;

@end
