//
//  Goal.h
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wish;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * limit;
@property (nonatomic, retain) NSNumber * isAchivement;
@property (nonatomic, retain) NSString * need;
@property (nonatomic, retain) Wish *wish;

@end
