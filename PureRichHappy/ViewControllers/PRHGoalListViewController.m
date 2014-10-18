//
//  PRHGoalListViewController.m
//  PureRichHappy
//
//  Created by Sei Takayuki on 2014/10/18.
//  Copyright (c) 2014年 Sei Takayuki. All rights reserved.
//

#import "PRHGoalListViewController.h"
#import "PRHGoalCell.h"
#import "Goal.h"
#import "Wish.h"
#import "ZFModalTransitionAnimator.h"
#import "JVFloatLabeledTextFieldViewController.h"
#import <AHKActionSheet.h>
#import <TOWebViewController.h>
#import <UIActionSheet+BlocksKit.h>
#import <MYBlurIntroductionView.h>
#import <UIAlertView+BlocksKit.h>

@import AddressBook;
@import AddressBookUI;

@interface PRHGoalListViewController () <UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate, MYIntroductionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *pfButton;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (IBAction)testDelete:(id)sender;

@end

@implementation PRHGoalListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:[PRHGoalCell getCaellIdentifier]
                                               bundle:nil]
         forCellReuseIdentifier:[PRHGoalCell getCaellIdentifier]];
    self.pfButton = [UIButton getCunstomPopFlatButton:self
                                             selector:@selector(tapFlatButton:)];
    [self.view addSubview:self.pfButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"didapper"
                                               object:nil];
    
    NSFetchRequest *request = [Goal MR_requestAllWhere:@"isAchivement"
                                                isEqualTo:@NO];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"limit"
                                                              ascending:NO]]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultsController performFetch:nil];
    self.fetchedResultsController = fetchedResultsController;
    [self.fetchedResultsController performFetch:nil];
    if (![PRHUserDefault standardUserDefaults].isDoneTutorial.boolValue) {
        [self buildIntro];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshTableView];
    
    if ([PRHUserDefault standardUserDefaults].isDoneTutorial.boolValue ) {//&& ![PRHUserDefault standardUserDefaults].isDoneAddressBook.boolValue) {
        [self showAddressBook];
        [PRHUserDefault standardUserDefaults].isDoneAddressBook = @YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger section;
    section = [[self.fetchedResultsController sections] count];
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRHGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:[PRHGoalCell getCaellIdentifier]];
    [cell setGoal:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PRHGoalCell getCellHeiht];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
    [actionSheet setTitle:[NSString stringWithFormat:@"%@,\n%@",goal.title, goal.wish.uri]];
    [actionSheet addButtonWithTitle:@"達成"
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                goal.isAchivement = @YES;
                                [self refreshTableView];
                                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                            }];
    [actionSheet addButtonWithTitle:@"削除" type:AHKActionSheetButtonTypeDestructive
                            handler:^(AHKActionSheet *actionSheet) {
                                [goal MR_deleteEntity];
                                [self refreshTableView];
                                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                            }];
    [actionSheet show];
}

- (void)tapFlatButton:(id)sender
{
    JVFloatLabeledTextFieldViewController *modalVC = [JVFloatLabeledTextFieldViewController new];
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    
    modalVC.transitioningDelegate = self.animator;
    [self presentViewController:modalVC animated:YES completion:nil];   // create animator object with instance of modal view controller
}

- (void)didTapActionWebView
{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"actionsheet"];
    [actionSheet bk_addButtonWithTitle:@"WishListを登録" handler:^{
        
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"キャンセル"
                                     handler:^{
                                         
                                     }];
    [actionSheet showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
}

#pragma mark - introduction view

-(void)buildIntro{
    //Create Stock Panel with header
    //Create Stock Panel With Image
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                                       title:@"Onedaryについて"
                                                                 description:@"Onedaryは、自分の目標管理におねだり機能をつけることによって、モチベーション高く目標を達成することをサポートするサービスです。"];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                                       title:@"おねだりについて"
                                                                 description:@"目標達成時に、誰か（親や嫁など）にAmazonのWishリストを一緒に送ることで、頑張った自分へのご褒美をもらっちゃうことを目指しています。"];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                                       title:@"はじめよう"
                                                                 description:@"まずはAmazonのWishListを登録しましょう。"];
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.95]];
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %ld", (long)panelIndex);
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
//    if (panelIndex == 0) {
//        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
//    }
//    //If it is the second panel, change the color to blue!
//    else if (panelIndex == 1){
//        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:0.65]];
//    }
}

- (void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    [PRHUserDefault standardUserDefaults].isDoneTutorial = @YES;
    NSURL *url = [NSURL URLWithString:@"http://www.amazon.co.jp/gp/registry/wishlist"];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController]
                       animated:YES completion:^{
                           [webViewController.actionButton addTarget:self
                                                              action:@selector(didTapActionWebView)
                                                    forControlEvents:UIControlEventTouchUpInside];
                       }];   // create animator object with instance of modal view controller
}

#pragma mark - Addressbook

- (void)showAddressBook{
    
    // NSArray *properties = @[@(kABPersonEmailProperty),@(kABPersonPhoneProperty)];

    ABPeoplePickerNavigationController *apnvc = [ABPeoplePickerNavigationController new];
    apnvc.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    apnvc.peoplePickerDelegate = self;
    [self presentViewController:apnvc animated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    // email
    ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *email;
    if (ABMultiValueGetCount(emailRef) > 0) {
        email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailRef, 0);
        NSLog(@"%@", email);
    }
    
    [peoplePicker dismissViewControllerAnimated:YES
                                     completion:nil];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES
                                     completion:nil];
}

#pragma mark - unko 

- (void)refreshTableView
{
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)testDelete:(id)sender
{
    [Goal MR_truncateAll];
    [self refreshTableView];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
