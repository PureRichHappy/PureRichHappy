//
//  PRHGoalCell.h
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@interface PRHGoalCell : UITableViewCell

+ (NSString *)getCaellIdentifier;
+ (CGFloat)getCellHeiht;

- (void)setGoal:(Goal *)goal;

@end
