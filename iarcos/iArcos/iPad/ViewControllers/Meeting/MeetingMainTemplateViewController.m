//
//  MeetingMainTemplateViewController.m
//  iArcos
//
//  Created by David Kilmartin on 31/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateViewController.h"

@interface MeetingMainTemplateViewController ()

@end

@implementation MeetingMainTemplateViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
@synthesize meetingDetailsTableViewController = _meetingDetailsTableViewController;
@synthesize layoutDict = _layoutDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Meeting";
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
    
    self.meetingDetailsTableViewController = [[[MeetingDetailsTableViewController alloc] initWithNibName:@"MeetingDetailsTableViewController" bundle:nil] autorelease];
    self.layoutDict = @{@"AuxDetails" : self.meetingDetailsTableViewController.view};
    
    [self addChildViewController:self.meetingDetailsTableViewController];
    [self.templateView addSubview:self.meetingDetailsTableViewController.view];
    [self.meetingDetailsTableViewController didMoveToParentViewController:self];
    [self.meetingDetailsTableViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxDetails]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxDetails]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.templateView = nil;
    self.meetingDetailsTableViewController = nil;
    self.layoutDict = nil;
    
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
