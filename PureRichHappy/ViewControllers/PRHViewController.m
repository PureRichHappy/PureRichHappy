//
//  PRHViewController.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHViewController.h"

@interface PRHViewController ()
@end

@implementation PRHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupBackgroundColor];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
