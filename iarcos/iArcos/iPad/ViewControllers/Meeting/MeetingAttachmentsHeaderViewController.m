//
//  MeetingAttachmentsHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsHeaderViewController.h"

@interface MeetingAttachmentsHeaderViewController ()

@end

@implementation MeetingAttachmentsHeaderViewController
@synthesize actionDelegate = _actionDelegate;
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
    NSLog(@"adc");
//    self.actionDelegate
}

@end
