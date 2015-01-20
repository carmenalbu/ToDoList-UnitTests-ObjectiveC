//
//  GenericUtils.m
//  ToDoList
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "GenericUtils.h"

@implementation GenericUtils

static GenericUtils *ref = nil;

+ (void)initialize
{
   ref = [GenericUtils sharedInstance];
}

+(GenericUtils *) sharedInstance {
    if( ref == nil ){
        ref = [[GenericUtils alloc] init];
    }
    return ref;
}

+(void) printAllFonts {
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(void) showAlertViewWithTitleAndOneButton:(NSString *)title andMessage:(NSString *)message withClosure:(AlertViewClosure)closure {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithTitle:title message:message delegate:ref cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.closure = closure;
    [alertView show];
}

+(void) showAlertViewWithTitleAndTwoButtons:(NSString *)title andMessage:(NSString *)message withClosure:(AlertViewClosure)closure {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithTitle:title message:message delegate:ref cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alertView.closure = closure;
    [alertView show];
}

-(void)alertView:(BaseAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    AlertViewClosure closure = alertView.closure;
    closure( buttonIndex );
}

@end
