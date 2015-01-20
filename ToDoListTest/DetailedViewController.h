//
//  DetailedViewController.h
//  ToDoListTest
//
//  Created by Carmen Albu on 19/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoModel.h"

@interface DetailedViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) ToDoModel *toDoModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeBarItem;

- (IBAction)action_completeBarItem:(id)sender;

@end
