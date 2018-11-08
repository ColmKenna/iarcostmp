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
@synthesize meetingMiscTableViewController = _meetingMiscTableViewController;
@synthesize layoutKeyList = _layoutKeyList;
@synthesize layoutObjectList = _layoutObjectList;
@synthesize objectViewControllerList = _objectViewControllerList;
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
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
    
    self.meetingDetailsTableViewController = [[[MeetingDetailsTableViewController alloc] initWithNibName:@"MeetingDetailsTableViewController" bundle:nil] autorelease];
    self.meetingMiscTableViewController = [[[MeetingMiscTableViewController alloc] initWithNibName:@"MeetingMiscTableViewController" bundle:nil] autorelease];
    self.layoutKeyList = [NSArray arrayWithObjects:@"AuxDetails", @"AuxMisc", nil];
    self.layoutObjectList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController.view, self.meetingMiscTableViewController.view, nil];
    self.objectViewControllerList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController, self.meetingMiscTableViewController, nil];
    
    self.layoutDict = [NSDictionary dictionaryWithObjects:self.layoutObjectList forKeys:self.layoutKeyList];
//    self.layoutDict = @{@"AuxDetails" : self.meetingDetailsTableViewController.view,
//                        @"AuxMisc" : self.meetingMiscTableViewController.view };
    for (int i = 0; i < [self.layoutKeyList count]; i++) {
        NSString* tmpLayoutKey = [self.layoutKeyList objectAtIndex:i];
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        [self addChildViewController:tmpObjectViewController];
        [self.templateView addSubview:tmpObjectViewController.view];
        [tmpObjectViewController didMoveToParentViewController:self];
        [tmpObjectViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
    }
//    [self addChildViewController:self.meetingDetailsTableViewController];
//    [self.templateView addSubview:self.meetingDetailsTableViewController.view];
//    [self.meetingDetailsTableViewController didMoveToParentViewController:self];
//    [self.meetingDetailsTableViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxDetails]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
//    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxDetails]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self segmentedAction];
    
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.templateView = nil;
    self.meetingDetailsTableViewController = nil;
    self.meetingMiscTableViewController = nil;
    for (int i = 0; i < [self.objectViewControllerList count]; i++) {
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        [tmpObjectViewController willMoveToParentViewController:nil];
        [tmpObjectViewController.view removeFromSuperview];
        [tmpObjectViewController removeFromParentViewController];
    }
    self.layoutDict = nil;
    self.layoutKeyList = nil;
    self.layoutObjectList = nil;
    self.objectViewControllerList = nil;
    
    [super dealloc];
}

- (void)segmentedAction {
    for (int i = 0; i < [self.objectViewControllerList count]; i++) {
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        tmpObjectViewController.view.hidden = YES;
    }
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.meetingDetailsTableViewController.view.hidden = NO;
        }
            break;
            
        case 1: {
            self.meetingMiscTableViewController.view.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

@end
