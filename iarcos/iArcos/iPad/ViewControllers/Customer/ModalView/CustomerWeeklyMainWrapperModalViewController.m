//
//  CustomerWeeklyMainWrapperModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerWeeklyMainWrapperModalViewController.h"

@implementation CustomerWeeklyMainWrapperModalViewController
@synthesize delegate;
@synthesize customiseContentView;
@synthesize customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }           
    if (self.customiseContentView != nil) { self.customiseContentView = nil;}
    if (self.customiseScrollContentView != nil) { self.customiseScrollContentView = nil; }         
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];    
    CustomerWeeklyMainModalViewController* cwmmvc =[[CustomerWeeklyMainModalViewController alloc]initWithNibName:@"CustomerWeeklyMainModalViewController" bundle:nil];
//    cwmmvc.delegate = self;
    //    cdmvc.title = [NSString stringWithFormat:@"Details for %@", [aCustDict objectForKey:@"Name"]];     
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cwmmvc] autorelease];
    [cwmmvc release];
    
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIView* aView in [self.customiseContentView subviews]) {
        [aView removeFromSuperview];
    }
    self.globalNavigationController = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didDismissModalView {
    [self.delegate didDismissModalView];
}
@end
