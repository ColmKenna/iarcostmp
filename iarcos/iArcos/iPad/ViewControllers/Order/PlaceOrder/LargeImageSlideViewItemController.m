//
//  LargeImageSlideViewItemController.m
//  Arcos
//
//  Created by David Kilmartin on 11/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeImageSlideViewItemController.h"

@implementation LargeImageSlideViewItemController
@synthesize indexPathRow = _indexPathRow;
@synthesize delegate = _delegate;
@synthesize myButton = _myButton;

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
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.myButton addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.myButton addGestureRecognizer:singleTap];
    [doubleTap release];
    [singleTap release];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)handleSingleTapGesture:(id)sender {
    [self.delegate didSelectLargeImageSlideViewItem:self.indexPathRow];
}

- (void)handleDoubleTapGesture:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didDoubleTapLargeImageSlideViewItem:)]) {
        [self.delegate didDoubleTapLargeImageSlideViewItem:self.indexPathRow];
    }
}

- (IBAction)pressButton:(id)sender {
    [self.delegate didSelectLargeImageSlideViewItem:self.indexPathRow];
}

- (void)clearContent {
    [self.myButton setImage:nil forState:UIControlStateNormal];
    self.delegate = nil;
}

@end
