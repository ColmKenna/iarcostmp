//
//  DetailingCalendarEventBoxListingViewController.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingViewController.h"

@interface DetailingCalendarEventBoxListingViewController ()

@end

@implementation DetailingCalendarEventBoxListingViewController
@synthesize myTableView = _myTableView;
@synthesize myDelegate = _myDelegate;
@synthesize detailingCalendarEventBoxListingDataManager = _detailingCalendarEventBoxListingDataManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
    
    self.detailingCalendarEventBoxListingDataManager = [[[DetailingCalendarEventBoxListingDataManager alloc] init] autorelease];
    self.myTableView.delegate = self.detailingCalendarEventBoxListingDataManager;
    self.myTableView.dataSource = self.detailingCalendarEventBoxListingDataManager;
//    [self.detailingCalendarEventBoxListingDataManager createBasicData];
    
}

- (void)dealloc {
    self.myTableView = nil;
    self.detailingCalendarEventBoxListingDataManager = nil;
    
    
    [super dealloc];
}

- (void)closePressed:(id)sender {
    [self.myDelegate didDismissCustomisePresentView];
}

@end
