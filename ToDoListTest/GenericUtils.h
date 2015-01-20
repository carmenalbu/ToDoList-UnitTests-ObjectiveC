//
//  GenericUtils.h
//  ToDoList
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "BaseAlertView.h"

@interface GenericUtils : NSObject <UIAlertViewDelegate>

+(GenericUtils *) sharedInstance;

+(void) printAllFonts;
+(BOOL) validateEmail:(NSString*)email;

+(void) showAlertViewWithTitleAndOneButton:(NSString *)title andMessage:(NSString *)message withClosure:(AlertViewClosure)closure;
+(void) showAlertViewWithTitleAndTwoButtons:(NSString *)title andMessage:(NSString *)message withClosure:(AlertViewClosure)closure;

@end
