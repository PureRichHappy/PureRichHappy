//
//  PRHGoalListViewController.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalListViewController.h"
#import "PRHGoalCell.h"
#import "Goal.h"
#import "ZFModalTransitionAnimator.h"
#import "JVFloatLabeledTextFieldViewController.h"

@interface PRHGoalListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *goals;
@property (nonatomic, strong) VBFPopFlatButton *pfButton;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

- (IBAction)test:(id)sender;
- (IBAction)testDelete:(id)sender;

@end

@implementation PRHGoalListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:[PRHGoalCell getCaellIdentifier]
                                               bundle:nil]
         forCellReuseIdentifier:[PRHGoalCell getCaellIdentifier]];
    self.pfButton = [UIButton getCunstomPopFlatButton:self
                                             selector:@selector(tapFlatButton:)];
    [self.view addSubview:self.pfButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.goals = [Goal MR_findAll];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goals.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRHGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:[PRHGoalCell getCaellIdentifier]];
    [cell setGoal:self.goals[indexPath.row]];
    return cell;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PRHGoalCell getCellHeiht];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tapFlatButton:(id)sender
{
    JVFloatLabeledTextFieldViewController *modalVC = [JVFloatLabeledTextFieldViewController new];
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    
    modalVC.transitioningDelegate = self.animator;
    [self presentViewController:modalVC animated:YES completion:nil];   // create animator object with instance of modal view controller
}

- (void)test:(id)sender
{
    Goal *goal = [Goal MR_createEntity];
    
    int rand = arc4random_uniform(100);
    goal.title = [NSString stringWithFormat:@"タイトルタイトル %d", rand];
    goal.limit = [NSDate date];
    goal.need = @"なんだろう";
    goal.isAchivement = NO;
    goal.wish = nil;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    self.goals = [Goal MR_findAll];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)testDelete:(id)sender
{
    [Goal MR_truncateAll];
    self.goals = [Goal MR_findAll];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
