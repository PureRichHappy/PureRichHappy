//
//  PRHGoalDescriptionViewController.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalDescriptionViewController.h"
#import "Goal.h"

@interface PRHGoalDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextArea;
@property (weak, nonatomic) IBOutlet UITextField *limitTextArea;
@property (weak, nonatomic) IBOutlet UITextField *wishTextArea;

@end

@implementation PRHGoalDescriptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)saveGoal
{
    Goal *goal = [Goal MR_createEntity];
    goal.title = [self.titleTextArea text];
    goal.limit = [NSDate date];
    goal.need = [self.wishTextArea text];
    goal.isAchivement = NO;
    goal.wish = nil;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
