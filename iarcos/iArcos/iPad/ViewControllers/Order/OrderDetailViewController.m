//
//  OrderDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderDetailViewController.h"


@implementation OrderDetailViewController
@synthesize myBarButtonItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (self.myBarButtonItem != nil) { self.myBarButtonItem = nil; }
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)reloadTableData{
    
}
- (void)reloadTableDataWithData:(NSMutableArray *)theData{
    
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
    /*
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsPortrait(orientation)||orientation==0) {
        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
    */
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (self.myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=self.myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}




#pragma mark - delgate

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
//    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
//    [itemsArray insertObject:barButtonItem atIndex:0];
//    [self.navigationController.toolbar setItems:itemsArray animated:NO];
//    [itemsArray release];
    /*
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
     */
    self.myBarButtonItem=barButtonItem;
    self.navigationItem.leftBarButtonItem=barButtonItem;
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
//    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
//    [itemsArray removeObject:barButtonItem];
//    [self.navigationController.toolbar setItems:itemsArray animated:NO];
//    [itemsArray release];
    //self.navigationItem.leftBarButtonItem=nil;
    /*
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
     */
    self.navigationItem.leftBarButtonItem=nil;

}
@end
