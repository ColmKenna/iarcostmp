//
//  SmallL5L3SearchFormRowSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "SmallL5L3SearchFormRowSlideViewController.h"
@interface SmallL5L3SearchFormRowSlideViewController ()
- (void)alignSubviews;
- (void)clearSmallL5L3SearchSlideViewItemContentWithIndex:(int)aItemIndex;
@end


@implementation SmallL5L3SearchFormRowSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize smallL5L3SearchFormRowDataManager = _smallL5L3SearchFormRowDataManager;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.smallL5L3SearchFormRowDataManager = [[[SmallL5L3SearchFormRowDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.smallL5L3SearchFormRowDataManager != nil) { self.smallL5L3SearchFormRowDataManager = nil; }    
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
    //    NSLog(@"viewWillAppear smallImageL5");
    [super viewWillAppear:animated];
    [self.smallL5L3SearchFormRowDataManager createSmallL5L3SearchSlideViewItemData];
    for (int i = 0; i < [self.smallL5L3SearchFormRowDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallL5L3SearchFormRowDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.delegate = self;
        aSISVIC.indexPathRow = i;
        [self.myScrollView addSubview:aSISVIC.view];
        [self.smallL5L3SearchFormRowDataManager fillSmallL5L3SearchSlideViewItemWithIndex:i];
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
    for (int i = 0; i < [self.smallL5L3SearchFormRowDataManager.slideViewItemList count]; i++) {
        [self clearSmallL5L3SearchSlideViewItemContentWithIndex:i];
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
    self.myScrollView.contentSize = CGSizeMake([self.smallL5L3SearchFormRowDataManager.displayList count] * itemWidth + ([self.smallL5L3SearchFormRowDataManager.displayList count] - 1), itemHeight);
    for (int i = 0; i < [self.smallL5L3SearchFormRowDataManager.slideViewItemList count]; i++) {
        SmallImageSlideViewItemController* aSISVIC = (SmallImageSlideViewItemController*)[self.smallL5L3SearchFormRowDataManager.slideViewItemList objectAtIndex:i];
        aSISVIC.view.frame = CGRectMake(i * itemWidth + i * 1, 0, itemWidth, itemHeight);
    }
}

#pragma mark SmallImageSlideViewItemDelegate
- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
    //    NSLog(@"didSelectSmallImageSlideViewItem anIndexPathRow: %d", anIndexPathRow);
    [self.delegate didSelectSmallImageSlideViewItem:anIndexPathRow];    
}

- (void)clearSmallL5L3SearchSlideViewItemContentWithIndex:(int)aItemIndex {
    SmallImageSlideViewItemController* tmpSISVIC = (SmallImageSlideViewItemController*)[self.smallL5L3SearchFormRowDataManager.slideViewItemList objectAtIndex:aItemIndex];
    
    [tmpSISVIC.view removeFromSuperview];
    [tmpSISVIC clearContent];
}

@end
