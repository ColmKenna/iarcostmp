//
//  PresenterSlideViewItemController.m
//  Arcos
//
//  Created by David Kilmartin on 26/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PresenterSlideViewItemController.h"

@implementation PresenterSlideViewItemController
@synthesize myWebView;
@synthesize myImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.myWebView != nil) { self.myWebView = nil; }
    if (self.myImage != nil) { self.myImage = nil; }    
    
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
    if (self.myWebView != nil) { self.myWebView = nil; }
    if (self.myImage != nil) { self.myImage = nil; }        
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
