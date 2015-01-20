//
//  BaseAlertView.h
//  ToDoList
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewClosure) (NSInteger index);

@interface BaseAlertView : UIAlertView

@property (nonatomic, strong) AlertViewClosure closure;

@end
