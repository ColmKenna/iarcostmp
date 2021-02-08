//
//  ReportMainTemplateViewController.m
//  iArcos
//
//  Created by Richard on 04/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReportMainTemplateViewController.h"

@interface ReportMainTemplateViewController ()

@end

@implementation ReportMainTemplateViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
@synthesize reportTableViewController = _reportTableViewController;
@synthesize reportNavigationController = _reportNavigationController;
@synthesize reporterXmlSubTableViewController = _reporterXmlSubTableViewController;
@synthesize reporterXmlGraphViewController = _reporterXmlGraphViewController;
@synthesize layoutKeyList = _layoutKeyList;
@synthesize layoutObjectList = _layoutObjectList;
@synthesize objectViewControllerList = _objectViewControllerList;
@synthesize layoutDict = _layoutDict;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.reportTableViewController = [[[ReportTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.reportNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.reportTableViewController] autorelease];
        self.reporterXmlSubTableViewController = [[[ReporterXmlSubTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.reporterXmlSubTableViewController.subTableDelegate = self;
        self.reporterXmlGraphViewController = [[[ReporterXmlGraphViewController alloc] initWithNibName:@"ReporterXmlGraphViewController" bundle:nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
//    [self.templateView.layer setCornerRadius:10.0];
    self.layoutKeyList = [NSArray arrayWithObjects:@"AuxListing", @"AuxSubTable", @"AuxGraph", nil];
    self.layoutObjectList = [NSArray arrayWithObjects:self.reportNavigationController.view, self.reporterXmlSubTableViewController.view, self.reporterXmlGraphViewController.view, nil];
    self.objectViewControllerList = [NSArray arrayWithObjects:self.reportNavigationController, self.reporterXmlSubTableViewController, self.reporterXmlGraphViewController, nil];
    
    self.layoutDict = [NSDictionary dictionaryWithObjects:self.layoutObjectList forKeys:self.layoutKeyList];
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

    [self segmentedAction];
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.templateView = nil;
    self.reportTableViewController = nil;
    self.reportNavigationController = nil;
    self.reporterXmlSubTableViewController = nil;
    self.reporterXmlGraphViewController = nil;
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
            self.reportNavigationController.view.hidden = NO;
            if (!self.reporterXmlSubTableViewController.reporterXmlSubDataManager.subTableRowPressed) {
                [self.reportTableViewController sortWithLinkIUR:self.reportTableViewController.nullStr];
            }
        }
            break;
            
        case 1: {
            self.reporterXmlSubTableViewController.view.hidden = NO;
        }
            break;
            
        case 2: {
            self.reporterXmlGraphViewController.view.hidden = NO;
        }
            break;
            
        
            
        default:
            break;
    }
}

#pragma mark ReporterXmlSubTableDelegate
- (void)subTableFooterPressed {
    self.mySegmentedControl.selectedSegmentIndex = 0;
    [self segmentedAction];
}

- (void)subTableRowPressedWithLinkIUR:(NSString *)aLinkIUR {
    self.mySegmentedControl.selectedSegmentIndex = 0;
    [self.reportTableViewController sortWithLinkIUR:aLinkIUR];
    [self segmentedAction];
}


@end
