//
//  OrderEntryInputRightHandSideGridViewController.m
//  iArcos
//
//  Created by Apple on 09/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputRightHandSideGridViewController.h"

@interface OrderEntryInputRightHandSideGridViewController ()

@end

@implementation OrderEntryInputRightHandSideGridViewController
@synthesize orderEntryInputRightHandSideHeaderView = _orderEntryInputRightHandSideHeaderView;
@synthesize rightHandSideGridView = _rightHandSideGridView;
@synthesize orderEntryInputRightHandSideGridDelegateController = _orderEntryInputRightHandSideGridDelegateController;
@synthesize orderEntryInputRightHandSideFooterView = _orderEntryInputRightHandSideFooterView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.orderEntryInputRightHandSideGridDelegateController = [[[OrderEntryInputRightHandSideGridDelegateController alloc] init] autorelease];
        self.orderEntryInputRightHandSideGridDelegateController.myDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rightHandSideGridView.dataSource = self.orderEntryInputRightHandSideGridDelegateController;
    self.rightHandSideGridView.delegate = self.orderEntryInputRightHandSideGridDelegateController;
    [self.rightHandSideGridView.layer setBorderColor:[self.myTableBorderColor CGColor]];
    [self.rightHandSideGridView.layer setBorderWidth:1.0];
    if ([self.rightHandSideGridView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.rightHandSideGridView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.rightHandSideGridView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.rightHandSideGridView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)dealloc {
    self.rightHandSideGridView = nil;
    self.orderEntryInputRightHandSideGridDelegateController = nil;
    self.orderEntryInputRightHandSideHeaderView = nil;
    self.orderEntryInputRightHandSideFooterView = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.orderEntryInputRightHandSideGridDelegateController retrieveRightHandSideGridData];
    [self.rightHandSideGridView reloadData];
    if ([self.orderEntryInputRightHandSideGridDelegateController.orderLineDictList count] > 0) {
        NSIndexPath* tmpIndexPath = [NSIndexPath indexPathForRow:[self.orderEntryInputRightHandSideGridDelegateController.orderLineDictList count] - 1 inSection:0];
        [self.rightHandSideGridView scrollToRowAtIndexPath:tmpIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark OrderEntryInputRightHandSideGridDelegateControllerDelegate

- (UIView*)retrieveRightHandSideGridHeaderView {
    return self.orderEntryInputRightHandSideHeaderView;
}

- (NSNumber*)retrieveLocationIUR {
    return self.locationIUR;
}

- (id)retrieveCellData {
    return self.Data;
}

- (UIView*)retrieveRightHandSideGridFooterView {
    return self.orderEntryInputRightHandSideFooterView;
}

@end
