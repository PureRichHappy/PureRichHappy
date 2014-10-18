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
#import <AHKActionSheet.h>

@interface PRHGoalListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *pfButton;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"didapper"
                                               object:nil];
    
    NSFetchRequest *request = [Goal MR_requestAllWhere:@"isAchivement"
                                                isEqualTo:@NO];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"limit"
                                                              ascending:NO]]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultsController performFetch:nil];
    self.fetchedResultsController = fetchedResultsController;
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger section;
    section = [[self.fetchedResultsController sections] count];
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRHGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:[PRHGoalCell getCaellIdentifier]];
    [cell setGoal:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PRHGoalCell getCellHeiht];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
    [actionSheet setTitle:goal.title];
    [actionSheet addButtonWithTitle:@"達成"
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                goal.isAchivement = @YES;
                                [self refreshTableView];
                            }];
    [actionSheet addButtonWithTitle:@"削除" type:AHKActionSheetButtonTypeDestructive
                            handler:^(AHKActionSheet *actionSheet) {
                                
                            }];
    [actionSheet show];
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

#pragma mark - unko 

- (void)refreshTableView
{
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

//- (void)test:(id)sender
//{
//    Goal *goal = [Goal MR_createEntity];
//    
//    int rand = arc4random_uniform(100);
//    goal.title = [NSString stringWithFormat:@"タイトルタイトル %d", rand];
//    goal.limit = [NSDate date];
//    goal.need = @"なんだろう";
//    goal.isAchivement = NO;
//    goal.wish = nil;
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    self.goals = [Goal MR_findAll];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                  withRowAnimation:UITableViewRowAnimationAutomatic];
//}

- (void)testDelete:(id)sender
{
    [Goal MR_truncateAll];
    [self refreshTableView];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
