//
//  DetailedViewController.m
//  ToDoListTest
//
//  Created by Carmen Albu on 18/01/15.
//  Copyright (c) 2015 Carmen Albu. All rights reserved.
//

#import "DetailedViewController.h"
#import "DataService.h"
#import "AppDelegate.h"

#define DEFAULT_TITLE @"Title"
#define DEFAULT_MESSAGE @"Description"

#define MARK_COMPLETED @"Mark Complete"
#define MARK_INCOMPLETE @"Mark Incomplete"

@interface DetailedViewController () {
        AppDelegate *appDelegate;
}

@property (nonatomic, retain) NSString* titleOld;
@property (nonatomic, retain) NSString* descriptionOld;
@property (nonatomic) BOOL completeStatusOld;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetup];
}

- (void) initSetup {
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.titleTextView.delegate = self.descriptionTextView.delegate = self;
    
    if(self.toDoModel != nil)
    {
        self.titleOld = self.titleTextView.text = self.toDoModel.itemTitle;
        self.descriptionOld = self.descriptionTextView.text = self.toDoModel.itemDescription;
        self.completeStatusOld = self.toDoModel.completed;
    }
    else
    {
        self.toDoModel = [[ToDoModel alloc] init];
        
        self.titleTextView.text = DEFAULT_TITLE;
        self.descriptionTextView.text = DEFAULT_MESSAGE;
        self.completeStatusOld = NO;
    }
    
    if(self.toDoModel.completed)
    {
        self.completeBarItem.title = MARK_INCOMPLETE;
    }
    else
    {
        self.completeBarItem.title = MARK_COMPLETED;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void) dismissKeyboard
{
    [self.titleTextView resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //check if title is not empty or with white spaces
    [self saveItem];
}

- (void) saveItem
{
    NSString *titleItem = [self.titleTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *descriptionItem = [self.descriptionTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //if the title, or description, or the completed status changed - save it
    if((![self.titleTextView.text isEqualToString:DEFAULT_TITLE] && titleItem.length > 0) || (![self.descriptionTextView.text isEqualToString:DEFAULT_MESSAGE] && descriptionItem.length > 0) || self.completeStatusOld != self.toDoModel.completed)
    {
        //do not accept empty title, you can accept empty description
        if(titleItem.length  == 0)
        {
            self.toDoModel.itemTitle = DEFAULT_TITLE;
        }
        else
        {
            self.toDoModel.itemTitle = self.titleTextView.text;
        }
        
        self.toDoModel.itemDescription = self.descriptionTextView.text;
        
        if(![self.toDoModel.itemDescription isEqualToString:self.descriptionOld] || ![self.toDoModel.itemTitle isEqualToString:self.titleOld] || self.completeStatusOld != self.toDoModel.completed)
        {
            //if(self.indexPath == nil)
            {
                if(self.toDoModel.completed)
                {
                    if([appDelegate.completedItems containsObject:self.toDoModel])
                    {
                        [appDelegate.completedItems removeObject:self.toDoModel];
                        [appDelegate.completedItems insertObject:self.toDoModel atIndex:0];
                    }
                    else if ([appDelegate.incompletedItems containsObject:self.toDoModel])
                    {
                        [appDelegate.incompletedItems removeObject:self.toDoModel];
                        [appDelegate.completedItems insertObject:self.toDoModel atIndex:0];
                    }
                    else
                    {
                        [appDelegate.completedItems insertObject:self.toDoModel atIndex:0];
                    }
                }
                else
                {
                    if([appDelegate.incompletedItems containsObject:self.toDoModel])
                    {
                        [appDelegate.incompletedItems removeObject:self.toDoModel];
                        [appDelegate.incompletedItems insertObject:self.toDoModel atIndex:0];
                    }
                    else if ([appDelegate.completedItems containsObject:self.toDoModel])
                    {
                        [appDelegate.completedItems removeObject:self.toDoModel];
                        [appDelegate.incompletedItems insertObject:self.toDoModel atIndex:0];
                    }
                    else
                    {
                        [appDelegate.incompletedItems insertObject:self.toDoModel atIndex:0];
                    }
                }
            }
            
            [DataService saveToDoItem:self.toDoModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"toDoItemModified" object:nil userInfo:nil];
        }
    }
}

- (IBAction)action_completeBarItem:(id)sender {
    
    if(self.toDoModel.completed)
    {
        self.toDoModel.completed = NO;
        self.completeBarItem.title = MARK_COMPLETED;
    }
    else
    {
        self.toDoModel.completed = YES;
        self.completeBarItem.title = MARK_INCOMPLETE;
    }
}

@end
