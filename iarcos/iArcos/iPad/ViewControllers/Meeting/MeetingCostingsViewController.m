//
//  MeetingCostingsViewController.m
//  iArcos
//
//  Created by David Kilmartin on 16/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingCostingsViewController.h"

@interface MeetingCostingsViewController ()
- (void)maskExpensesTemplateView;
@end

@implementation MeetingCostingsViewController
@synthesize budgetTemplateView = _budgetTemplateView;
@synthesize expensesTemplateView = _expensesTemplateView;
@synthesize budgetNavigationBar = _budgetNavigationBar;
@synthesize expensesNavigationBar = _expensesNavigationBar;
@synthesize budgetTableView = _budgetTableView;
@synthesize expensesTableView = _expensesTableView;
@synthesize meetingCostingsDataManager = _meetingCostingsDataManager;
@synthesize templateViewList = _templateViewList;
@synthesize addBarButtonItem = _addBarButtonItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.templateViewList = [NSArray arrayWithObjects:self.budgetTemplateView, self.expensesTemplateView, nil];
    [self maskTemplateViewWithView:self.budgetTemplateView];
    
    NSMutableArray* barButtonItemList = [NSMutableArray arrayWithCapacity:2];
    
    self.addBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonPressed)] autorelease];
    [barButtonItemList addObject:self.addBarButtonItem];
//    self.expensesNavigationBar.topItem.rightBarButtonItem = addBarButtonItem;
    
    UIBarButtonItem* editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBarButtonPressed)];
    [barButtonItemList addObject:editBarButtonItem];
//    self.expensesNavigationBar.topItem.leftBarButtonItem = editBarButtonItem;
    [editBarButtonItem release];
    self.expensesNavigationBar.topItem.rightBarButtonItems = barButtonItemList;
}

- (void)dealloc {
    self.budgetTemplateView = nil;
    self.expensesTemplateView = nil;
    self.budgetNavigationBar = nil;
    self.expensesNavigationBar = nil;
    self.budgetTableView = nil;
    self.expensesTableView = nil;
    self.meetingCostingsDataManager = nil;
    self.templateViewList = nil;
    self.addBarButtonItem = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self maskExpensesTemplateView];
}

- (void)maskExpensesTemplateView {
    [self maskTemplateViewWithView:self.expensesTemplateView];
}

- (void)maskTemplateViewWithView:(UIView*)aView {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
    [maskLayer release];
}

- (void)addBarButtonPressed {
    NSLog(@"add pressed");
    MeetingExpenseDetailsViewController* meetingExpenseDetailsViewController = [[MeetingExpenseDetailsViewController alloc] initWithNibName:@"MeetingExpenseDetailsViewController" bundle:nil];
    meetingExpenseDetailsViewController.preferredContentSize = CGSizeMake(380.0f, 44*5 + 50);
    meetingExpenseDetailsViewController.modalDelegate = self;
    meetingExpenseDetailsViewController.modalPresentationStyle = UIModalPresentationPopover;
    meetingExpenseDetailsViewController.popoverPresentationController.barButtonItem = self.addBarButtonItem;
    [self presentViewController:meetingExpenseDetailsViewController animated:YES completion:^{
        
    }];
    [meetingExpenseDetailsViewController release];
}

- (void)editBarButtonPressed {
    NSLog(@"edit pressed");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self maskExpensesTemplateView];
    }];
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
