//
//  PRHModelManager.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHModelManager.h"

static id sharedInstance = nil;

@implementation PRHModelManager

+ (id)sharedInstance 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

@end
