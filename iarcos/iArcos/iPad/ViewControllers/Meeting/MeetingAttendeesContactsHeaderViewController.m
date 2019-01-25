//
//  MeetingAttendeesContactsHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesContactsHeaderViewController.h"

@interface MeetingAttendeesContactsHeaderViewController ()

@end

@implementation MeetingAttendeesContactsHeaderViewController
@synthesize addButton = _addButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.addButton = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"ac0");
}

@end
