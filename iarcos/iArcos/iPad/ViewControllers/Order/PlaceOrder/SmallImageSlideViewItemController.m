//
//  SmallImageSlideViewItemController.m
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "SmallImageSlideViewItemController.h"

@implementation SmallImageSlideViewItemController
@synthesize indexPathRow = _indexPathRow;
@synthesize delegate = _delegate;
@synthesize myButton = _myButton;
@synthesize myLabel = _myLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.delegate != nil) { self.delegate = nil; }
    if (self.myButton != nil) {
        [self.myButton setImage:nil forState:UIControlStateNormal];
        self.myButton = nil; 
    }
    if (self.myLabel != nil) { self.myLabel = nil; }    
    
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
    if (self.myButton != nil) {
        [self.myButton setImage:nil forState:UIControlStateNormal];
        self.myButton = nil; 
    }
    if (self.myLabel != nil) { self.myLabel = nil; }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)pressButton:(id)sender {
    [self.delegate didSelectSmallImageSlideViewItem:self.indexPathRow];
}

- (void)clearContent {
    [self.myButton setImage:nil forState:UIControlStateNormal];
    self.delegate = nil;
    self.myLabel.text = nil;
}

@end
