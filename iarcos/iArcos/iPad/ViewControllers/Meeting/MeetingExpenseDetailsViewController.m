//
//  MeetingExpenseDetailsViewController.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsViewController.h"

@interface MeetingExpenseDetailsViewController ()

@end

@implementation MeetingExpenseDetailsViewController
@synthesize meetingExpenseDetailsDataManager = _meetingExpenseDetailsDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingExpenseDetailsDataManager = [[[MeetingExpenseDetailsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.meetingExpenseDetailsDataManager = nil;
    
    [super dealloc];
}

@end
