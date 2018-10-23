//
//  SmallImageL5FormRowsSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "SmallImageL5FormRowsSlideViewController.h"
@interface SmallImageL5FormRowsSlideViewController ()
- (void)alignSubviews;
- (void)clearSmallImageL5SlideViewItemContentWithIndex:(int)aItemIndex;
@end

@implementation SmallImageL5FormRowsSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize smallImageL5FormRowsDataManager = _smallImageL5FormRowsDataManager;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.smallImageL5FormRowsDataManager = [[[SmallImageL5FormRowsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.smallImageL5FormRowsDataManager != nil) { self.smallImageL5FormRowsDataManager = nil; }    
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
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"viewWillAppear smallImageL5");
    [super viewWillAppear:animated];
    [self.smallImageL5FormRowsDataManager createSmallImageL5SlideViewItemData];
    for (int i = 0; i < [self.smallImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallImageL5FormRowsDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.delegate = self;
        aSISVIC.indexPathRow = i;
        [self.myScrollView addSubview:aSISVIC.view];
        [self.smallImageL5FormRowsDataManager fillSmallImageL5SlideViewItemWithIndex:i];
    }
    [self alignSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear smallImageL5");
    [super viewDidAppear:animated];
    //    NSLog(@"viewDidAppear bounds l5:%f, %f",self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"viewWillDisappear smallImageL5");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    NSLog(@"viewDidDisappear smallImageL5");
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.smallImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        [self clearSmallImageL5SlideViewItemContentWithIndex:i];
//        NSLog(@"clearSmallImageL5SlideViewItemContentWithIndex: %d", i);
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
    self.myScrollView.contentSize = CGSizeMake([self.smallImageL5FormRowsDataManager.displayList count] * itemWidth + ([self.smallImageL5FormRowsDataManager.displayList count] - 1), itemHeight);
    for (int i = 0; i < [self.smallImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallImageL5FormRowsDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.view.frame = CGRectMake(i * itemWidth + i * 1, 0, itemWidth, itemHeight);
    }
}

- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectSmallImageSlideViewItem anIndexPathRow: %d", anIndexPathRow);
    [self.delegate didSelectSmallImageSlideViewItem:anIndexPathRow];    
}

- (void)clearSmallImageL5SlideViewItemContentWithIndex:(int)aItemIndex {
    SmallImageSlideViewItemController* tmpSISVIC = (SmallImageSlideViewItemController*)[self.smallImageL5FormRowsDataManager.slideViewItemList objectAtIndex:aItemIndex];
    
    [tmpSISVIC.view removeFromSuperview];
    [tmpSISVIC clearContent];
}

@end
