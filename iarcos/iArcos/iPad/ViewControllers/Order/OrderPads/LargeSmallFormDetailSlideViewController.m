//
//  LargeSmallFormDetailSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallFormDetailSlideViewController.h"
@interface LargeSmallFormDetailSlideViewController ()
- (void)alignSubviews;
- (void)createSmallFormDetailDividerSlideViewController:(int)anIndexPathRow;
- (void)toggleSmallFormDetailDividerSlideView:(int)anIndexPathRow;
- (void)toggleSmallFormDetailDividerSlideViewProcessCenter;
- (void)clearSmallFormDetailDividerSlideViewController;
- (void)toggleSmallFormDetailDividerSlideViewProcessCenter4ScrollView;
- (void)showProductViewWithDividerDict:(NSMutableDictionary*)aDividerDict;
- (void)clearLargeSmallFormDetailSlideViewContentWithIndex:(int)aPageIndex;
- (void)loadLargeSmallFormDetailSlideViewItemWithIndex:(int)aPageIndex;
- (void)unloadLargeSmallFormDetailSlideViewItemWithIndex:(int)aPageIndex;
- (void)loadBufferLargeSmallFormDetailSlideViewItem;
- (void)unloadNotBufferLargeSmallFormDetailSlideViewItem;
- (void)countValidLargeSmallFormDetailSlideViewItem;
@end

@implementation LargeSmallFormDetailSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize largeSmallFormDetailDataManager = _largeSmallFormDetailDataManager;
@synthesize formIUR = _formIUR;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize smallFormDetailDividerSlideViewController = _smallFormDetailDividerSlideViewController;
@synthesize slideUpViewHeight = _slideUpViewHeight;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;


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
    if (self.myScrollView != nil) { self.myScrollView = nil; }    
    if (self.largeSmallFormDetailDataManager != nil) { self.largeSmallFormDetailDataManager = nil; }
    if (self.formIUR != nil) { self.formIUR = nil; }
    if (self.backButtonDelegate != nil) { self.backButtonDelegate = nil; }
    if (self.smallFormDetailDividerSlideViewController != nil) { self.smallFormDetailDividerSlideViewController = nil; }
    
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
    self.navigationController.navigationBarHidden = YES;
    self.largeSmallFormDetailDataManager = [[[LargeSmallFormDetailDataManager alloc] init] autorelease];
    self.slideUpViewHeight = 177.0f;
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
    if (!self.isNotFirstLoaded) {
        [self.largeSmallFormDetailDataManager getFormDividerDetail:self.formIUR];
        self.isNotFirstLoaded = YES;
    }
    
    [self.largeSmallFormDetailDataManager createPlaceholderLargeSmallFormDetailSlideViewItemData];
    [self loadBufferLargeSmallFormDetailSlideViewItem];
    if (self.isSlideUpViewShowing) {
        self.smallFormDetailDividerSlideViewController.delegate = self;
        [self.view addSubview:self.smallFormDetailDividerSlideViewController.view];
        [self.smallFormDetailDividerSlideViewController viewWillAppear:YES];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallFormDetailDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//   [self countValidLargeSmallFormDetailSlideViewItem];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallFormDetailDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.largeSmallFormDetailDataManager.slideViewItemList count]; i++) {
        [self clearLargeSmallFormDetailSlideViewContentWithIndex:i];
    }
    if (self.isSlideUpViewShowing) {
        self.smallFormDetailDividerSlideViewController.delegate = nil;
        [self.smallFormDetailDividerSlideViewController.view removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration {
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [self alignSubviews];
	self.myScrollView.contentOffset = CGPointMake(self.largeSmallFormDetailDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.largeSmallFormDetailDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.largeSmallFormDetailDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallFormDetailDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)aLISVIC == [NSNull null]) {
        } else {
            aLISVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
        }        
    }
    
    if (self.isSlideUpViewShowing) {
        CGRect myScrollViewBounds = self.myScrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        if (self.isSlideUpViewShowing) {
            slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
        } else {
            slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
        }
        self.smallFormDetailDividerSlideViewController.view.frame = slideUpViewFrame;        
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{    
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {    
    self.largeSmallFormDetailDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.isSlideUpViewShowing && self.largeSmallFormDetailDataManager.currentPage != self.largeSmallFormDetailDataManager.previousPage) {
        [self toggleSmallFormDetailDividerSlideViewProcessCenter4ScrollView];
    }
    if (self.largeSmallFormDetailDataManager.currentPage != self.largeSmallFormDetailDataManager.previousPage) {
        self.largeSmallFormDetailDataManager.previousPage = self.largeSmallFormDetailDataManager.currentPage;
        [self loadBufferLargeSmallFormDetailSlideViewItem];
        [self unloadNotBufferLargeSmallFormDetailSlideViewItem];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallFormDetailDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLargeSmallFormDetailSlideViewItem];
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectLargeSmallImageSlideViewItem: %d", anIndexPathRow);    
    NSMutableDictionary* dividerDict = [self.largeSmallFormDetailDataManager.displayList objectAtIndex:anIndexPathRow];    
    NSNumber* hasProductFlag = [dividerDict objectForKey:@"HasProduct"];
    if ([hasProductFlag boolValue]) {
//        NSLog(@"dividerDict: %@", dividerDict);
        [self showProductViewWithDividerDict:dividerDict];
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    } else {
        NSMutableArray* subDividerDictList = [dividerDict objectForKey:@"SubDivider"];
//        NSLog(@"subDividerDictList: %@", subDividerDictList);
        if ([subDividerDictList count] == 1) {
            NSMutableDictionary* subDividerDict = [subDividerDictList objectAtIndex:0];
            [self showProductViewWithDividerDict:subDividerDict];
            [self.backButtonDelegate controlOrderFormBackButtonEvent];
        } else {
            [self toggleSmallFormDetailDividerSlideView:anIndexPathRow];
        }
    }    
}

- (void)createSmallFormDetailDividerSlideViewController:(int)anIndexPathRow {    
    NSMutableDictionary* dividerDict = [self.largeSmallFormDetailDataManager.displayList objectAtIndex:anIndexPathRow];
    NSMutableArray* subDividerDictList = [dividerDict objectForKey:@"SubDivider"];
    if ([subDividerDictList count] > 1) {
        self.smallFormDetailDividerSlideViewController = [[[SmallFormDetailDividerSlideViewController alloc] initWithNibName:@"SmallFormDetailDividerSlideViewController" bundle:nil] autorelease];
        self.smallFormDetailDividerSlideViewController.delegate = self;
        self.smallFormDetailDividerSlideViewController.smallFormDetailDividerDataManager.currentIndexPathRow = anIndexPathRow;
        self.smallFormDetailDividerSlideViewController.smallFormDetailDividerDataManager.displayList = [NSMutableArray arrayWithArray:subDividerDictList];
        CGRect myScrollViewBounds = self.myScrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        self.smallFormDetailDividerSlideViewController.view.frame = slideUpViewFrame;
        [self.view addSubview:self.smallFormDetailDividerSlideViewController.view];
    }
}

- (void)toggleSmallFormDetailDividerSlideView:(int)anIndexPathRow {
    if (!self.isSlideUpViewShowing) {
        [self createSmallFormDetailDividerSlideViewController:anIndexPathRow];
    }    
    [self toggleSmallFormDetailDividerSlideViewProcessCenter];
}

- (void)toggleSmallFormDetailDividerSlideViewProcessCenter {
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    if (self.isSlideUpViewShowing) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.smallFormDetailDividerSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            [self clearSmallFormDetailDividerSlideViewController];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.smallFormDetailDividerSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            
        }];
    }    
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

- (void)toggleSmallFormDetailDividerSlideViewProcessCenter4ScrollView {
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.smallFormDetailDividerSlideViewController.view setFrame:slideUpViewFrame];
    } completion:^(BOOL finished){
        [self clearSmallFormDetailDividerSlideViewController];
    }];
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

#pragma mark SmallImageSlideViewItemDelegate
- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
    NSMutableDictionary* subDividerDict = [self.smallFormDetailDividerSlideViewController.smallFormDetailDividerDataManager.displayList objectAtIndex:anIndexPathRow];
    [self showProductViewWithDividerDict:subDividerDict];
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)clearSmallFormDetailDividerSlideViewController {
    self.smallFormDetailDividerSlideViewController.delegate = nil;
    [self.smallFormDetailDividerSlideViewController.view removeFromSuperview];    
}

- (void)showProductViewWithDividerDict:(NSMutableDictionary*)aDividerDict {
    FormRowsTableViewController* FRTVC = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
    FRTVC.isShowingSearchBar = YES;
    NSNumber* dividerIUR = [aDividerDict objectForKey:@"IUR"];
    [FRTVC resetDataWithDividerRecordIUR:dividerIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [self.navigationController pushViewController:FRTVC animated:YES];
    [FRTVC release];
    NSLog(@"show product view");
}

- (void)clearLargeSmallFormDetailSlideViewContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallFormDetailDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLISVIC == [NSNull null]) {
        return;
    }
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}

- (void)loadLargeSmallFormDetailSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallFormDetailDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallFormDetailDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC != [NSNull null]) {
        return;
    }
    LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
    
    [self.largeSmallFormDetailDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LISVIC];
    [LISVIC release];
    
    LISVIC.delegate = self;
    LISVIC.indexPathRow = aPageIndex;
    [self.myScrollView addSubview:LISVIC.view];
    [self.largeSmallFormDetailDataManager fillLargeSmallFormDetailSlideViewItemWithIndex:aPageIndex];
}

- (void)unloadLargeSmallFormDetailSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallFormDetailDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallFormDetailDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC == [NSNull null]) {
        return;
    }
    [self clearLargeSmallFormDetailSlideViewContentWithIndex:aPageIndex];
    [self.largeSmallFormDetailDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}

- (void)loadBufferLargeSmallFormDetailSlideViewItem {
    for (int i = self.largeSmallFormDetailDataManager.currentPage - self.largeSmallFormDetailDataManager.halfBufferSize; i <= self.largeSmallFormDetailDataManager.currentPage + self.largeSmallFormDetailDataManager.halfBufferSize; i++) {
        [self loadLargeSmallFormDetailSlideViewItemWithIndex:i];
    }
}

- (void)unloadNotBufferLargeSmallFormDetailSlideViewItem {
    for (int i = 0; i < self.largeSmallFormDetailDataManager.currentPage - self.largeSmallFormDetailDataManager.halfBufferSize; i++) {
        [self unloadLargeSmallFormDetailSlideViewItemWithIndex:i];
    }
    for (int j = self.largeSmallFormDetailDataManager.currentPage + self.largeSmallFormDetailDataManager.halfBufferSize + 1; j < [self.largeSmallFormDetailDataManager.slideViewItemList count]; j++) {
        [self unloadLargeSmallFormDetailSlideViewItemWithIndex:j];
    }
}

- (void)countValidLargeSmallFormDetailSlideViewItem {
    int count = 0;
    for (int i = 0; i < [self.largeSmallFormDetailDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallFormDetailDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLISVIC != [NSNull null]) {
            count++;
            NSLog(@"valid index: %d",i);
        }
    }
    NSLog(@"currentpage: %d total count: %d",self.largeSmallFormDetailDataManager.currentPage, count);
}

@end
