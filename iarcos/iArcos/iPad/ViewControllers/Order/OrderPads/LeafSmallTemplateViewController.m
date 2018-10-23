//
//  LeafSmallTemplateViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LeafSmallTemplateViewController.h"
@interface LeafSmallTemplateViewController ()
- (void)alignSubviews;
- (void)clearLeafSmallTemplateViewContentWithIndex:(int)aPageIndex;
- (void)loadLeafSmallTemplateViewItemWithIndex:(int)aPageIndex;
- (void)unloadLeafSmallTemplateViewItemWithIndex:(int)aPageIndex;
- (void)loadBufferLeafSmallTemplateViewItem;
- (void)unloadNotBufferLeafSmallTemplateViewItem;
- (void)countValidLeafSmallTemplateViewItem;
- (void)scrollViewDidEndDeceleratingProcessor;
@end

@implementation LeafSmallTemplateViewController
@synthesize myScrollView = _myScrollView;
@synthesize leafSmallTemplateDataManager = _leafSmallTemplateDataManager;
@synthesize delegate = _delegate;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.leafSmallTemplateDataManager = [[[LeafSmallTemplateDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.leafSmallTemplateDataManager != nil) { self.leafSmallTemplateDataManager = nil; }   
    
    
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
    if (!self.isNotFirstLoaded) {
        [self.leafSmallTemplateDataManager createLeafSmallTemplateViewItemData];
        self.isNotFirstLoaded = YES;
    }    
    [self.leafSmallTemplateDataManager createPlaceholderLeafSmallTemplateViewItemData];
    [self loadBufferLeafSmallTemplateViewItem];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLeafSmallTemplateViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"leaf small viewDidAppear");
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.leafSmallTemplateDataManager.slideViewItemList count]; i++) {
        [self clearLeafSmallTemplateViewContentWithIndex:i];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self alignSubviews];
	self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
    for (int i = 0; i < [self.leafSmallTemplateDataManager.slideViewItemList count]; i++) {
        LeafSmallTemplateViewItemController* aLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)aLSTVIC == [NSNull null]) {
        } else {
            [aLSTVIC willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        }
    }
}

- (void)alignSubviews {
//    NSLog(@"leaf small alignsubviews: %@", NSStringFromCGRect(self.myScrollView.frame));
    self.myScrollView.contentSize = CGSizeMake([self.leafSmallTemplateDataManager.slideViewItemList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.leafSmallTemplateDataManager.slideViewItemList count]; i++) {
        LeafSmallTemplateViewItemController* aLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)aLSTVIC == [NSNull null]) {
        } else {
            aLSTVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
            [aLSTVIC alignSubviews];
        }        
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
    [self scrollViewDidEndDeceleratingProcessor];
//    self.leafSmallTemplateDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;        
//    if (self.leafSmallTemplateDataManager.currentPage != self.leafSmallTemplateDataManager.previousPage) {
//        self.leafSmallTemplateDataManager.previousPage = self.leafSmallTemplateDataManager.currentPage;
//        [self loadBufferLeafSmallTemplateViewItem];
//        [self unloadNotBufferLeafSmallTemplateViewItem];
//    }    
//    [self alignSubviews];
//    self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLeafSmallTemplateViewItem];
}

#pragma mark LeafSmallTemplateViewItemDelegate
-(void)didSelectSmallTemplateViewItemWithButton:(UIButton*)aBtn indexPathRow:(int)anIndexPathRow {
//    NSLog(@"smallTemplateViewItemWithButton: %d %d", aBtn.tag, anIndexPathRow);
    [self.delegate didSelectSmallTemplateViewItemWithButton:aBtn indexPathRow:anIndexPathRow];
}

- (void)clearLeafSmallTemplateViewContentWithIndex:(int)aPageIndex {
    LeafSmallTemplateViewItemController* tmpLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLSTVIC == [NSNull null]) {
        return;
    }
    [tmpLSTVIC.view removeFromSuperview];
    [tmpLSTVIC clearAllInfo];
}

- (void)loadLeafSmallTemplateViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.leafSmallTemplateDataManager.pagedDisplayList count]) {
        return;
    }
    LeafSmallTemplateViewItemController* aLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLSTVIC != [NSNull null]) {
        return;
    }
    LeafSmallTemplateViewItemController* LSTVIC = [[LeafSmallTemplateViewItemController alloc]initWithNibName:@"LeafSmallTemplateViewItemController" bundle:nil];
    
    [self.leafSmallTemplateDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LSTVIC];
    [LSTVIC release];
    
    LSTVIC.delegate = self;
    LSTVIC.indexPathRow = aPageIndex;
    LSTVIC.itemPerPage = self.leafSmallTemplateDataManager.itemPerPage;
    [self.myScrollView addSubview:LSTVIC.view];
    [self.leafSmallTemplateDataManager fillLeafSmallTemplateViewItemWithIndex:aPageIndex];
}

- (void)unloadLeafSmallTemplateViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.leafSmallTemplateDataManager.pagedDisplayList count]) {
        return;
    }
    LeafSmallTemplateViewItemController* aLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLSTVIC == [NSNull null]) {
        return;
    }
    [self clearLeafSmallTemplateViewContentWithIndex:aPageIndex];
    [self.leafSmallTemplateDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}

- (void)loadBufferLeafSmallTemplateViewItem {
    for (int i = self.leafSmallTemplateDataManager.currentPage - self.leafSmallTemplateDataManager.halfBufferSize; i <= self.leafSmallTemplateDataManager.currentPage + self.leafSmallTemplateDataManager.halfBufferSize; i++) {
        [self loadLeafSmallTemplateViewItemWithIndex:i];
    }
}

- (void)unloadNotBufferLeafSmallTemplateViewItem {
    for (int i = 0; i < self.leafSmallTemplateDataManager.currentPage - self.leafSmallTemplateDataManager.halfBufferSize; i++) {
        [self unloadLeafSmallTemplateViewItemWithIndex:i];
    }
    for (int j = self.leafSmallTemplateDataManager.currentPage + self.leafSmallTemplateDataManager.halfBufferSize + 1; j < [self.leafSmallTemplateDataManager.slideViewItemList count]; j++) {
        [self unloadLeafSmallTemplateViewItemWithIndex:j];
    }
}

- (void)countValidLeafSmallTemplateViewItem {
    int count = 0;
    for (int i = 0; i < [self.leafSmallTemplateDataManager.slideViewItemList count]; i++) {
        LeafSmallTemplateViewItemController* tmpLSTVIC = (LeafSmallTemplateViewItemController*)[self.leafSmallTemplateDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLSTVIC != [NSNull null]) {
            count++;
            NSLog(@"ls valid index: %d",i);
        }
    }
    NSLog(@"ls currentpage: %d total count: %d",self.leafSmallTemplateDataManager.currentPage, count);
}

- (void)jumpToSpecificPage:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.leafSmallTemplateDataManager.pagedDisplayList count] || aPageIndex == self.leafSmallTemplateDataManager.currentPage) {
        return;
    }
    self.leafSmallTemplateDataManager.currentPage = aPageIndex;
    if (self.leafSmallTemplateDataManager.currentPage != self.leafSmallTemplateDataManager.previousPage) {
        self.leafSmallTemplateDataManager.previousPage = self.leafSmallTemplateDataManager.currentPage;
        [self loadBufferLeafSmallTemplateViewItem];
        [self unloadNotBufferLeafSmallTemplateViewItem];
    }    
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)showSpecificPage:(int)aPageIndex {
    int pageIndex = aPageIndex / self.leafSmallTemplateDataManager.itemPerPage;
    self.myScrollView.contentOffset = CGPointMake(pageIndex * self.myScrollView.bounds.size.width, 0);
    [self scrollViewDidEndDeceleratingProcessor];
}

- (void)scrollViewDidEndDeceleratingProcessor {
    self.leafSmallTemplateDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.leafSmallTemplateDataManager.currentPage != self.leafSmallTemplateDataManager.previousPage) {
        self.leafSmallTemplateDataManager.previousPage = self.leafSmallTemplateDataManager.currentPage;
        [self loadBufferLeafSmallTemplateViewItem];
        [self unloadNotBufferLeafSmallTemplateViewItem];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.leafSmallTemplateDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}


@end
