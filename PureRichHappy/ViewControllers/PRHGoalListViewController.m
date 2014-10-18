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

@interface PRHGoalListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *goals;

@end

@implementation PRHGoalListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:[PRHGoalCell getCaellIdentifier]
                                               bundle:nil]
         forCellReuseIdentifier:[PRHGoalCell getCaellIdentifier]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.goals = [Goal MR_findAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup 

- (void)setupBackgroundColor
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[
                        // 開始色
                        (id)[UIColor colorWithRed:.23 green:.64 blue:.90 alpha:1].CGColor,
                        // 終了色
                        (id)[UIColor colorWithRed:.20 green:.63 blue:.72 alpha:1].CGColor
                        ];
    [self.view.layer insertSublayer:gradient atIndex:0];
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

@end
