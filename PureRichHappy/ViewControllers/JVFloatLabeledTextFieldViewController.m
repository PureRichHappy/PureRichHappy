//
//  JVFloatLabeledTextFieldViewController.m
//  JVFloatLabeledTextField
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Jared Verdi
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




#import "JVFloatLabeledTextFieldViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "Goal.h"
#import <RDVCalendarView.h>

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

CGFloat const static kPRHCalenderBeginY = -568;
CGFloat const static kPRHCalenderShowY = 0;
CGSize const static kPRHBaseCalenderSize = {320, 400};

@interface JVFloatLabeledTextFieldViewController () <UITextFieldDelegate, RDVCalendarViewDelegate>

@property (nonatomic, strong) JVFloatLabeledTextField *titleField;
@property (nonatomic, strong) JVFloatLabeledTextField *limitField;
@property (nonatomic, strong) JVFloatLabeledTextField *wishField;
@property (nonatomic, strong) RDVCalendarView *calendar;

@property (nonatomic, strong) NSDate *limitDate;

@end

@implementation JVFloatLabeledTextFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Floating Label Demo", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.calendar = [[RDVCalendarView alloc] initWithFrame:CGRectMake(0, kPRHCalenderBeginY, kPRHBaseCalenderSize.width, kPRHBaseCalenderSize.height)];
    [self.calendar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.calendar setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [self.calendar setBackgroundColor:[UIColor whiteColor]];
    [self.calendar setDelegate:self];
    
    CGFloat topOffset = 0;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self.view setTintColor:[UIColor blueColor]];
    
    topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
#endif
    
    UIColor *floatingLabelColor = [UIColor brownColor];
    
    self.titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    self.titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Title", @"")
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, self.titleField.frame.origin.y + self.titleField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    self.limitField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, div1.frame.origin.y + div1.frame.size.height, 320.0f, kJVFieldHeight)];
    self.limitField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Limit", @"")
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.limitField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.limitField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.limitField.floatingLabelTextColor = floatingLabelColor;
    self.limitField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.limitField.delegate = self;
    [self.view addSubview:self.limitField];
    
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin + self.limitField.frame.size.width,
                            self.titleField.frame.origin.y + self.titleField.frame.size.height,
                            1.0f, kJVFieldHeight);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    
    self.wishField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin,
                                                         div1.frame.origin.y + div1.frame.size.height + div2.frame.size.height,
                                                         self.view.frame.size.width - 3*kJVFieldHMargin - 1.0f,
                                                         kJVFieldHeight)];
    self.wishField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Wish", @"")
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.wishField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.wishField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.wishField.floatingLabelTextColor = floatingLabelColor;
    self.wishField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.wishField.delegate = self;
    [self.view addSubview:self.wishField];
    
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, self.limitField.frame.origin.y + self.limitField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    
    [self.titleField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveGoal
{
    Goal *goal = [Goal MR_createEntity];
    goal.title = [self.titleField text];
    goal.limit = self.limitDate;
    goal.need = [self.wishField text];
    goal.isAchivement = NO;
    goal.wish = nil;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.limitField]) {
        [textField resignFirstResponder];
        [self.view addSubview:self.calendar];
        [UIView animateWithDuration:0.4f
                         animations:^{
                             self.calendar.frame = CGRectMake(0, kPRHCalenderShowY, kPRHBaseCalenderSize.width, kPRHBaseCalenderSize.height);
                         }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.wishField]) {
        if (![self.titleField.text isEqualToString:@""] && ![self.limitField.text isEqualToString:@""] && ![self.wishField.text isEqualToString: @""]) {
            [self saveGoal];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didapper"
                                                                object:nil
                                                              userInfo: nil];
        }
    }
    
    return YES;
}

#pragma mark - calender delegate

- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    NSString* dateString;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    dateString = [formatter stringFromDate:date];
    
    self.limitDate = date;
    self.limitField.text = dateString;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.calendar.frame = CGRectMake(0, kPRHCalenderBeginY, kPRHBaseCalenderSize.width, kPRHBaseCalenderSize.height);
                     } completion:^(BOOL finished) {
                         
                         [calendarView removeFromSuperview];
                     }];
}

@end
