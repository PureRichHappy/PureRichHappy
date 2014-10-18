//
//  UIButton+VBFPopFlatButton.h
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VBFPopFlatButton.h>
#import <POP.h>

@interface UIButton (VBFPopFlatButton)
+ (VBFPopFlatButton *)getCunstomPopFlatButton:(id)target selector:(SEL)selector;
- (void)tapAnimate;

@end

@implementation UIButton (VBFPopFlatButton)
+ (VBFPopFlatButton *)getCunstomPopFlatButton:(id)target selector:(SEL)selector
{
    VBFPopFlatButton *flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(250, [UIScreen mainScreen].bounds.size.height - 75, 30, 30)
                                                                      buttonType:buttonAddType
                                                                     buttonStyle:buttonRoundedStyle
                                                           animateToInitialState:YES];
    flatRoundedButton.roundBackgroundColor = [UIColor whiteColor];
    flatRoundedButton.lineThickness = 2;
    flatRoundedButton.tintColor = [UIColor colorWithRed:.20 green:.63 blue:.72 alpha:1];
    [flatRoundedButton addTarget:target
                          action:selector
                forControlEvents:UIControlEventTouchUpInside];
    return flatRoundedButton;
}

- (void)tapAnimate
{
//    POPSpringAnimation *anim =
//    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 35, 35)];
//    anim.springSpeed = 5.0f;
//    anim.springBounciness = 24.0f;
//    [self pop_addAnimation:anim forKey:@"size"];
}

@end