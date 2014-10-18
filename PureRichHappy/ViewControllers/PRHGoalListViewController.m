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
@property (nonatomic, strong) VBFPopFlatButton *pfButton;

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
    
}

@end
