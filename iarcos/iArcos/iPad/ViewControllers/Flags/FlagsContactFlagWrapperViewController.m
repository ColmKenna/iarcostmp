//
//  FlagsContactFlagWrapperViewController.m
//  iArcos
//
//  Created by Richard on 16/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactFlagWrapperViewController.h"

@interface FlagsContactFlagWrapperViewController ()

@end

@implementation FlagsContactFlagWrapperViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize contactFlagViewHolder = _contactFlagViewHolder;
@synthesize flagsContactFlagTableViewController = _flagsContactFlagTableViewController;
@synthesize flagsContactFlagNavigationController = _flagsContactFlagNavigationController;
@synthesize layoutDict = _layoutDict;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.flagsContactFlagTableViewController = [[[FlagsContactFlagTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsContactFlagTableViewController.actionDelegate = self;
        self.flagsContactFlagTableViewController.refreshDelegate = self;
        self.flagsContactFlagNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsContactFlagTableViewController] autorelease];
        self.layoutDict = @{@"AuxFlagsContactFlag" : self.flagsContactFlagNavigationController.view};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addChildViewController:self.flagsContactFlagNavigationController];
    [self.contactFlagViewHolder addSubview:self.flagsContactFlagNavigationController.view];
    [self.flagsContactFlagNavigationController didMoveToParentViewController:self];
    [self.flagsContactFlagNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contactFlagViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxFlagsContactFlag]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.contactFlagViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxFlagsContactFlag]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
     
}

- (void)dealloc {
    [self.flagsContactFlagNavigationController willMoveToParentViewController:nil];
    [self.flagsContactFlagNavigationController.view removeFromSuperview];
    [self.flagsContactFlagNavigationController removeFromParentViewController];
    self.contactFlagViewHolder = nil;
    self.flagsContactFlagTableViewController = nil;
    self.flagsContactFlagNavigationController = nil;
    self.layoutDict = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - ModelViewDelegate
-(void)didDismissModalView {
    [self.actionDelegate didDismissModalView];
}

#pragma mark - FlagsContactFlagTableViewControllerDelegate
- (void)refreshParentContentWithContactFlagIUR:(NSNumber *)anIUR {
    [self.refreshDelegate refreshParentContentWithContactFlagIUR:anIUR];
}
- (NSString*)retrieveParentFlagDescrTypeCode {
    return [self.refreshDelegate retrieveParentFlagDescrTypeCode];
}
- (NSString*)retrieveParentActionTypeTitle {
    return [self.refreshDelegate retrieveParentActionTypeTitle];
}

@end
