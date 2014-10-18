//
//  PRHGoalListViewController.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalListViewController.h"

@interface PRHGoalListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PRHGoalListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
