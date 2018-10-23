//
//  SplitViewCommonMasterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SplitViewCommonMasterViewController.h"


@implementation SplitViewCommonMasterViewController
@synthesize popoverController, splitViewController, rootPopoverButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
#pragma mark - Split view controller delegate

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Utilities";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

@end
