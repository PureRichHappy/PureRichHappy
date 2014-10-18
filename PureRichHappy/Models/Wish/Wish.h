//
//  Wish.h
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Wish : NSManagedObject

@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSManagedObject *goal;

@end
