//
//  PRHGoalCell.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalCell.h"

@interface PRHGoalCell ()
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@end

CGFloat static cellHeight = 44;

@implementation PRHGoalCell

+ (NSString *)getCaellIdentifier
{
    return  NSStringFromClass([self class]);
}

+ (CGFloat)getCellHeiht
{
    return cellHeight;
}

- (void)setGoal:(Goal *)goal
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.debugLabel.text = goal.isAchivement.boolValue ? @"YES" : @"NO";
    self.titleLabel.text = goal.title;
    
    NSString* dateString;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    dateString = [formatter stringFromDate:goal.limit];
    self.limitLabel.text = dateString;
}

@end
