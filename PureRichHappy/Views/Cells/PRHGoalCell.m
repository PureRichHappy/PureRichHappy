//
//  PRHGoalCell.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalCell.h"

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
    
}

@end
