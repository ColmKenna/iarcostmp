//
//  MeetingAttendeesOthersHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 07/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesOthersHeaderViewController.h"

@interface MeetingAttendeesOthersHeaderViewController ()

@end

@implementation MeetingAttendeesOthersHeaderViewController
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
    MeetingAttendeesOthersItemTableViewController* meetingAttendeesOthersItemTableViewController = [[MeetingAttendeesOthersItemTableViewController alloc] initWithNibName:@"MeetingAttendeesOthersItemTableViewController" bundle:nil];
    meetingAttendeesOthersItemTableViewController.actionDelegate = self;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:meetingAttendeesOthersItemTableViewController];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 200.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.addButton;
    
    [[self.actionDelegate retrieveParentViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    [tmpNavigationController release];
    [meetingAttendeesOthersItemTableViewController release];
}

#pragma mark MeetingAttendeesOthersItemTableViewControllerDelegate
- (void)didDismissOthersItemPopover {
    [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressedWithName:(NSString *)aName organisation:(NSString *)anOrganisation {
    
}

@end
