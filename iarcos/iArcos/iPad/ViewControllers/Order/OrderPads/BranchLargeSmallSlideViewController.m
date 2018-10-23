//
//  BranchLargeSmallSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLargeSmallSlideViewController.h"
@interface BranchLargeSmallSlideViewController ()
- (void)alignSubviews;
- (void)clearBranchLargeSmallSlideViewContentWithIndex:(int)aPageIndex;
- (void)loadBranchLargeSmallSlideViewItemWithIndex:(int)aPageIndex;
- (void)unloadBranchLargeSmallSlideViewItemWithIndex:(int)aPageIndex;
- (void)loadBufferBranchLargeSmallSlideViewItem;
- (void)unloadNotBufferBranchLargeSmallSlideViewItem;
- (void)countValidBranchLargeSmallSlideViewItem;
- (void)toggleLeafSmallTemplateView:(int)anIndexPathRow;
- (void)toggleLeafSmallTemplateViewProcessCenter;
- (void)toggleLeafSmallTemplateViewProcessCenter4ScrollView;
- (void)createLeafSmallTableViewController:(int)anIndexPathRow;
- (void)clearLeafSmallTemplateView;
- (void)productListLargeImageSlideViewItem:(int)anIndexPathRow;
- (void)productGridLargeImageSlideViewItem:(int)anIndexPathRow;
- (void)productGridDoubleTapLargeImageSlideViewItem:(int)anIndexPathRow;
- (void)genericProductGridLargeImageSlideViewItem:(int)anIndexPathRow type:(int)aType;
@end

@implementation BranchLargeSmallSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize branchLargeSmallDataManager = _branchLargeSmallDataManager;
@synthesize formType = _formType;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize leafSmallTemplateViewController = _leafSmallTemplateViewController;
@synthesize slideUpViewHeight = _slideUpViewHeight;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize navigationTitleDelegate = _navigationTitleDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.branchLargeSmallDataManager != nil) { self.branchLargeSmallDataManager = nil; }
    if (self.formType != nil) { self.formType = nil; }        
    if (self.leafSmallTemplateViewController != nil) { self.leafSmallTemplateViewController = nil; }
    
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
    self.branchLargeSmallDataManager = [[[BranchLargeSmallDataManager alloc] init] autorelease];
    self.branchLargeSmallDataManager.formType = self.formType;
//    NSLog(@"self.branchLargeSmallDataManager.formType: %@", self.branchLargeSmallDataManager.formType);
    self.slideUpViewHeight = 116.0f;
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
    if (!self.isNotFirstLoaded) {
        [self.branchLargeSmallDataManager getBranchLeafData];
        self.isNotFirstLoaded = YES;
    }    
    [self.branchLargeSmallDataManager createPlaceholderBranchLargeSmallSlideViewItemData];
    [self loadBufferBranchLargeSmallSlideViewItem];
    if (self.isSlideUpViewShowing) {
//        self.leafSmallTemplateViewController.delegate = self;
        [self.view addSubview:self.leafSmallTemplateViewController.view];
        [self.leafSmallTemplateViewController viewWillAppear:YES];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.branchLargeSmallDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidBranchLargeSmallSlideViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self alignSubviews];
    [self.leafSmallTemplateViewController viewDidAppear:YES];
    self.myScrollView.contentOffset = CGPointMake(self.branchLargeSmallDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.branchLargeSmallDataManager.slideViewItemList count]; i++) {
        [self clearBranchLargeSmallSlideViewContentWithIndex:i];
    }
    if (self.isSlideUpViewShowing) {
        [self.leafSmallTemplateViewController.view removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [self alignSubviews];
	self.myScrollView.contentOffset = CGPointMake(self.branchLargeSmallDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
    if (self.isSlideUpViewShowing) {
        [self.leafSmallTemplateViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    }    
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.branchLargeSmallDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.branchLargeSmallDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.branchLargeSmallDataManager.slideViewItemList objectAtIndex:i];
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
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;        
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
    self.branchLargeSmallDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.isSlideUpViewShowing && self.branchLargeSmallDataManager.currentPage != self.branchLargeSmallDataManager.previousPage) {
        [self toggleLeafSmallTemplateViewProcessCenter4ScrollView];
    }
    if (self.branchLargeSmallDataManager.currentPage != self.branchLargeSmallDataManager.previousPage) {
        self.branchLargeSmallDataManager.previousPage = self.branchLargeSmallDataManager.currentPage;
        [self loadBufferBranchLargeSmallSlideViewItem];
        [self unloadNotBufferBranchLargeSmallSlideViewItem];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.branchLargeSmallDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidBranchLargeSmallSlideViewItem];
}

- (void)clearBranchLargeSmallSlideViewContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.branchLargeSmallDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLISVIC == [NSNull null]) {
        return;
    }
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}

- (void)loadBranchLargeSmallSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.branchLargeSmallDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.branchLargeSmallDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC != [NSNull null]) {
        return;
    }
    LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
    
    [self.branchLargeSmallDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LISVIC];
    [LISVIC release];
    
    LISVIC.delegate = self;
    LISVIC.indexPathRow = aPageIndex;
    [self.myScrollView addSubview:LISVIC.view];
    [self.branchLargeSmallDataManager fillBranchLargeSmallSlideViewItemWithIndex:aPageIndex];
}

- (void)unloadBranchLargeSmallSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.branchLargeSmallDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.branchLargeSmallDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC == [NSNull null]) {
        return;
    }
    [self clearBranchLargeSmallSlideViewContentWithIndex:aPageIndex];
    [self.branchLargeSmallDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}

- (void)loadBufferBranchLargeSmallSlideViewItem {
    for (int i = self.branchLargeSmallDataManager.currentPage - self.branchLargeSmallDataManager.halfBufferSize; i <= self.branchLargeSmallDataManager.currentPage + self.branchLargeSmallDataManager.halfBufferSize; i++) {
        [self loadBranchLargeSmallSlideViewItemWithIndex:i];
    }
}

- (void)unloadNotBufferBranchLargeSmallSlideViewItem {
    for (int i = 0; i < self.branchLargeSmallDataManager.currentPage - self.branchLargeSmallDataManager.halfBufferSize; i++) {
        [self unloadBranchLargeSmallSlideViewItemWithIndex:i];
    }
    for (int j = self.branchLargeSmallDataManager.currentPage + self.branchLargeSmallDataManager.halfBufferSize + 1; j < [self.branchLargeSmallDataManager.slideViewItemList count]; j++) {
        [self unloadBranchLargeSmallSlideViewItemWithIndex:j];
    }
}

- (void)countValidBranchLargeSmallSlideViewItem {
    int count = 0;
    for (int i = 0; i < [self.branchLargeSmallDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.branchLargeSmallDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLISVIC != [NSNull null]) {
            count++;
            NSLog(@"valid index: %d",i);
        }
    }
    NSLog(@"currentpage: %d total count: %d",self.branchLargeSmallDataManager.currentPage, count);
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
    //    NSLog(@"didSelectLargeSmallImageSlideViewItem: %d", anIndexPathRow);
//    NSLog(@"self.branchLargeSmallDataManager.formTypeId: %@",self.branchLargeSmallDataManager.formTypeId);
    switch ([self.branchLargeSmallDataManager.formTypeId intValue]) {
        case 4:
            [self productListLargeImageSlideViewItem:anIndexPathRow];
            break;
        case 5:
            [self productGridLargeImageSlideViewItem:anIndexPathRow];
            break;
        default:
            break;
    }    
}
- (void)didDoubleTapLargeImageSlideViewItem:(int)anIndexPathRow {
    switch ([self.branchLargeSmallDataManager.formTypeId intValue]) {
        case 5:
            [self productGridDoubleTapLargeImageSlideViewItem:anIndexPathRow];
            break;
        default:
            break;
    }
}

- (void)toggleLeafSmallTemplateView:(int)anIndexPathRow {
    if (!self.isSlideUpViewShowing) {
        [self createLeafSmallTableViewController:anIndexPathRow];
    }
    [self toggleLeafSmallTemplateViewProcessCenter];
}

- (void)createLeafSmallTableViewController:(int)anIndexPathRow {
    NSMutableDictionary* branchDescrDetailDict = [self.branchLargeSmallDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* branchDescrDetailCode = [branchDescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* leafChildrenList = [branchDescrDetailDict objectForKey:@"LeafChildren"];
    if ([leafChildrenList count] > 1) {
        self.leafSmallTemplateViewController = [[[LeafSmallTemplateViewController alloc] initWithNibName:@"LeafSmallTemplateViewController" bundle:nil] autorelease];
        self.leafSmallTemplateViewController.delegate = self;
        self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode = [NSString stringWithFormat:@"%@", branchDescrDetailCode];
        self.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:leafChildrenList];
        CGRect myScrollViewBounds = self.myScrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
        [self.view addSubview:self.leafSmallTemplateViewController.view];
    }
    
}

- (void)toggleLeafSmallTemplateViewProcessCenter {
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    if (self.isSlideUpViewShowing) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.leafSmallTemplateViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            [self clearLeafSmallTemplateView];            
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.leafSmallTemplateViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            
        }];
    }    
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

- (void)toggleLeafSmallTemplateViewProcessCenter4ScrollView {
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.leafSmallTemplateViewController.view setFrame:slideUpViewFrame];
    } completion:^(BOOL finished){
        [self clearLeafSmallTemplateView];
    }];
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
} 

- (void)clearLeafSmallTemplateView {
//    self.leafSmallTemplateViewController.delegate = nil;
    [self.leafSmallTemplateViewController.view removeFromSuperview];    
}

#pragma mark LeafSmallTemplateViewItemDelegate
-(void)didSelectSmallTemplateViewItemWithButton:(UIButton*)aBtn indexPathRow:(int)anIndexPathRow {
//    NSLog(@"didSelectSbranchlargesmallslideview %d %d",aBtn.tag, anIndexPathRow);
    NSMutableArray* subsetDisplayList = [self.leafSmallTemplateViewController.leafSmallTemplateDataManager.pagedDisplayList objectAtIndex:anIndexPathRow];
    NSMutableDictionary* cellDataDict = [subsetDisplayList objectAtIndex:aBtn.tag];
    NSString* leafDescrDetailCode = [cellDataDict objectForKey:@"DescrDetailCode"];
//    NSLog(@"abc: %@ %@ %@ %@", self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode, self.branchLargeSmallDataManager.branchLxCode, leafDescrDetailCode, self.branchLargeSmallDataManager.leafLxCode);
    self.branchLargeSmallDataManager.branchLeafProductBaseDataManager.leafSmallTemplateViewController = self.leafSmallTemplateViewController;
    [self.navigationController pushViewController:[self.branchLargeSmallDataManager.branchLeafProductBaseDataManager showProductTableViewController:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode branchLxCode:self.branchLargeSmallDataManager.branchLxCode leafLxCodeContent:leafDescrDetailCode leafLxCode:self.branchLargeSmallDataManager.leafLxCode] animated:YES];
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)productListLargeImageSlideViewItem:(int)anIndexPathRow {
    NSMutableDictionary* branchDescrDetailDict = [self.branchLargeSmallDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* branchDescrDetailCode = [branchDescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* leafChildrenList = [branchDescrDetailDict objectForKey:@"LeafChildren"];
    
    if ([leafChildrenList count] == 1) {        
        NSString* leafDescrDetailCode = [[leafChildrenList objectAtIndex:0] objectForKey:@"DescrDetailCode"];
        
        [self.navigationController pushViewController:[self.branchLargeSmallDataManager.branchLeafProductBaseDataManager showProductTableViewController:branchDescrDetailCode branchLxCode:self.branchLargeSmallDataManager.branchLxCode leafLxCodeContent:leafDescrDetailCode leafLxCode:self.branchLargeSmallDataManager.leafLxCode] animated:YES];
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    } else {
        [self toggleLeafSmallTemplateView:anIndexPathRow];
    }
}

- (void)productGridLargeImageSlideViewItem:(int)anIndexPathRow {
    [self genericProductGridLargeImageSlideViewItem:anIndexPathRow type:1];
}

- (void)productGridDoubleTapLargeImageSlideViewItem:(int)anIndexPathRow {
    [self genericProductGridLargeImageSlideViewItem:anIndexPathRow type:2];
}
//1: one tap 2: two tap
- (void)genericProductGridLargeImageSlideViewItem:(int)anIndexPathRow type:(int)aType {
    NSMutableDictionary* branchDescrDetailDict = [self.branchLargeSmallDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* branchDescrDetailCode = [branchDescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* leafChildrenList = [branchDescrDetailDict objectForKey:@"LeafChildren"];
    BranchLeafProductGridViewController* BLPGVC = [[BranchLeafProductGridViewController alloc] initWithNibName:@"BranchLeafProductGridViewController" bundle:nil];
    BLPGVC.navigationTitleDelegate = self;
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode = [NSString stringWithFormat:@"%@", branchDescrDetailCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLxCode = [NSString stringWithFormat:@"%@", self.branchLargeSmallDataManager.branchLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.leafLxCode = [NSString stringWithFormat:@"%@", self.branchLargeSmallDataManager.leafLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:leafChildrenList];
    if (aType == 2) {
        [BLPGVC productListDoubleTapLargeImage];
    }
    [self.navigationController pushViewController:BLPGVC animated:YES];
    [BLPGVC release];
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

#pragma mark BranchLeafProductNavigationTitleDelegate
- (void)resetTopBranchLeafProductNavigationTitle:(NSString*)aDetail {
    [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:aDetail];
}

@end
