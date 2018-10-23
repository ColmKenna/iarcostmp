//
//  SmallFormDetailDividerSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "SmallFormDetailDividerSlideViewController.h"
@interface SmallFormDetailDividerSlideViewController ()
- (void)alignSubviews;
- (void)clearSmallFormDetailDividerSlideViewItemContentWithIndex:(int)aItemIndex;
@end

@implementation SmallFormDetailDividerSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize smallFormDetailDividerDataManager = _smallFormDetailDividerDataManager;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.smallFormDetailDividerDataManager = [[[SmallFormDetailDividerDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.smallFormDetailDividerDataManager != nil) { self.smallFormDetailDividerDataManager = nil; }
    if (self.delegate != nil) { self.delegate = nil; }
    
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
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.myScrollView != nil) { self.myScrollView = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.smallFormDetailDividerDataManager createSmallFormDetailDividerSlideViewItemData];
    for (int i = 0; i < [self.smallFormDetailDividerDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallFormDetailDividerDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.delegate = self;
        aSISVIC.indexPathRow = i;
        [self.myScrollView addSubview:aSISVIC.view];
        [self.smallFormDetailDividerDataManager fillSmallFormDetailDividerSlideViewItemWithIndex:i];
    }
    [self alignSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];        
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.smallFormDetailDividerDataManager.slideViewItemList count]; i++) {
        [self clearSmallFormDetailDividerSlideViewItemContentWithIndex:i];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)alignSubviews {
    float itemWidth = 204;
    float itemHeight = 176;
    self.myScrollView.contentSize = CGSizeMake([self.smallFormDetailDividerDataManager.displayList count] * itemWidth + ([self.smallFormDetailDividerDataManager.displayList count] - 1), itemHeight);
    for (int i = 0; i < [self.smallFormDetailDividerDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallFormDetailDividerDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.view.frame = CGRectMake(i * itemWidth + i * 1, 0, itemWidth, itemHeight);
    }
}

- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
    //    NSLog(@"didSelectSmallImageSlideViewItem anIndexPathRow: %d", anIndexPathRow);
    [self.delegate didSelectSmallImageSlideViewItem:anIndexPathRow];    
}

- (void)clearSmallFormDetailDividerSlideViewItemContentWithIndex:(int)aItemIndex {
    SmallImageSlideViewItemController* tmpSISVIC = (SmallImageSlideViewItemController*)[self.smallFormDetailDividerDataManager.slideViewItemList objectAtIndex:aItemIndex];
    
    [tmpSISVIC.view removeFromSuperview];
    [tmpSISVIC clearContent];
}

@end
