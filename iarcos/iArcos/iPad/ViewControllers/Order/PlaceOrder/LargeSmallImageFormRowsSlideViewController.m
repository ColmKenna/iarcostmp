//
//  LargeSmallImageFormRowsSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 13/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallImageFormRowsSlideViewController.h"
@interface LargeSmallImageFormRowsSlideViewController ()
- (void)alignSubviews;
- (void)createSmallImageL5FormRowsSlideViewController:(int)anIndexPathRow;
- (void)toggleSmallImageL5FormRowsSlideView:(int)anIndexPathRow;
- (void)toggleSmallImageL5FormRowsSlideViewProcessCenter;
- (void)clearSmallImageL5FormRowsSlideViewController;
- (void)toggleSmallImageL5FormRowsSlideViewProcessCenter4ScrollView;
- (void)showProductViewWithL5Dict:(NSMutableDictionary*)aL5DescrDetailDict;
- (void)clearLargeSmallImageFormRowsSlideViewContentWithIndex:(int)aPageIndex;
- (void)loadLargeSmallImageSlideViewItemWithIndex:(int)aPageIndex;
- (void)unloadLargeSmallImageSlideViewItemWithIndex:(int)aPageIndex;
- (void)loadBufferLargeSmallImageSlideViewItem;
- (void)unloadNotBufferLargeSmallImageSlideViewItem;
- (void)countValidLargeSmallImageSlideViewItem;
@end

@implementation LargeSmallImageFormRowsSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize largeSmallImageFormRowsDataManager = _largeSmallImageFormRowsDataManager;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize smallImageL5FormRowsSlideViewController = _smallImageL5FormRowsSlideViewController;
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
    if (self.largeSmallImageFormRowsDataManager != nil) { self.largeSmallImageFormRowsDataManager = nil; }
    if (self.backButtonDelegate != nil) { self.backButtonDelegate = nil; }
    if (self.smallImageL5FormRowsSlideViewController != nil) { self.smallImageL5FormRowsSlideViewController = nil; }
                
    
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
    self.largeSmallImageFormRowsDataManager = [[[LargeSmallImageFormRowsDataManager alloc] init] autorelease];
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
//    NSLog(@"viewWillAppear largeSmallImage");
    [super viewWillAppear:animated];
    if (!self.isNotFirstLoaded) {
        [self.largeSmallImageFormRowsDataManager getLevel4DescrDetail];
        self.isNotFirstLoaded = YES;
    }
    
    /*
    [self.largeSmallImageFormRowsDataManager createLargeSmallImageSlideViewItemData];
    for (int i = 0; i < [self.largeSmallImageFormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:i];
        aLISVIC.delegate = self;
        aLISVIC.indexPathRow = i;        
        [self.myScrollView addSubview:aLISVIC.view];
        [self.largeSmallImageFormRowsDataManager fillLargeSmallImageSlideViewItemWithIndex:i];
    }
    */
    [self.largeSmallImageFormRowsDataManager createPlaceholderLargeSmallImageSlideViewItemData];
    [self loadBufferLargeSmallImageSlideViewItem];
    if (self.isSlideUpViewShowing) {
        self.smallImageL5FormRowsSlideViewController.delegate = self;
        [self.view addSubview:self.smallImageL5FormRowsSlideViewController.view];
        [self.smallImageL5FormRowsSlideViewController viewWillAppear:YES];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLargeSmallImageSlideViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear largeSmallImage");
    [super viewDidAppear:animated];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"viewWillDisappear largeSmallImage");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    NSLog(@"viewDidDisappear largeSmallImage");
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.largeSmallImageFormRowsDataManager.slideViewItemList count]; i++) {
        [self clearLargeSmallImageFormRowsSlideViewContentWithIndex:i];
    }
    if (self.isSlideUpViewShowing) {
        self.smallImageL5FormRowsSlideViewController.delegate = nil;
        [self.smallImageL5FormRowsSlideViewController.view removeFromSuperview];
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
	self.myScrollView.contentOffset = CGPointMake(self.largeSmallImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.largeSmallImageFormRowsDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.largeSmallImageFormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:i];
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
        self.smallImageL5FormRowsSlideViewController.view.frame = slideUpViewFrame;        
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
    self.largeSmallImageFormRowsDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.isSlideUpViewShowing && self.largeSmallImageFormRowsDataManager.currentPage != self.largeSmallImageFormRowsDataManager.previousPage) {
        [self toggleSmallImageL5FormRowsSlideViewProcessCenter4ScrollView];
    }
    if (self.largeSmallImageFormRowsDataManager.currentPage != self.largeSmallImageFormRowsDataManager.previousPage) {
        self.largeSmallImageFormRowsDataManager.previousPage = self.largeSmallImageFormRowsDataManager.currentPage;
        [self loadBufferLargeSmallImageSlideViewItem];
        [self unloadNotBufferLargeSmallImageSlideViewItem];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLargeSmallImageSlideViewItem];
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectLargeSmallImageSlideViewItem: %d", anIndexPathRow);
    NSMutableDictionary* l4DescrDetailDict = [self.largeSmallImageFormRowsDataManager.displayList objectAtIndex:anIndexPathRow];
//    NSString* l4DescrDetailCode = [l4DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l4DescrDetailDict objectForKey:@"L5Children"];
//    NSLog(@"l5ChildrenList: %d",[l5ChildrenList count]);
    if ([l5ChildrenList count] == 1) {
        [self showProductViewWithL5Dict:[l5ChildrenList objectAtIndex:0]];
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    } else {
        [self toggleSmallImageL5FormRowsSlideView:anIndexPathRow];
    }    
}

- (void)createSmallImageL5FormRowsSlideViewController:(int)anIndexPathRow {    
    NSMutableDictionary* l4DescrDetailDict = [self.largeSmallImageFormRowsDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* l4DescrDetailCode = [l4DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l4DescrDetailDict objectForKey:@"L5Children"];
//    NSLog(@"l5ChildrenList count: %d", [l5ChildrenList count]);
    if ([l5ChildrenList count] > 1) {
        self.smallImageL5FormRowsSlideViewController = [[[SmallImageL5FormRowsSlideViewController alloc] initWithNibName:@"SmallImageL5FormRowsSlideViewController" bundle:nil] autorelease];
        self.smallImageL5FormRowsSlideViewController.delegate = self;
        self.smallImageL5FormRowsSlideViewController.smallImageL5FormRowsDataManager.currentIndexPathRow = anIndexPathRow;
        self.smallImageL5FormRowsSlideViewController.smallImageL5FormRowsDataManager.descrDetailCode = [NSString stringWithFormat:@"%@",l4DescrDetailCode];
        self.smallImageL5FormRowsSlideViewController.smallImageL5FormRowsDataManager.displayList = [NSMutableArray arrayWithArray:l5ChildrenList];
        CGRect myScrollViewBounds = self.myScrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        self.smallImageL5FormRowsSlideViewController.view.frame = slideUpViewFrame;
        [self.view addSubview:self.smallImageL5FormRowsSlideViewController.view];
    }
    
}

- (void)toggleSmallImageL5FormRowsSlideView:(int)anIndexPathRow {
    if (!self.isSlideUpViewShowing) {
        [self createSmallImageL5FormRowsSlideViewController:anIndexPathRow];
    }    
    [self toggleSmallImageL5FormRowsSlideViewProcessCenter];
}

- (void)toggleSmallImageL5FormRowsSlideViewProcessCenter {
//    NSLog(@"toggleSmallImageL5FormRowsSlideViewProcessCenter");
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    if (self.isSlideUpViewShowing) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.smallImageL5FormRowsSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            [self clearSmallImageL5FormRowsSlideViewController];
//            NSLog(@"pop self.smallImageL5FormRowsSlideViewController: %@", self.smallImageL5FormRowsSlideViewController);
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.smallImageL5FormRowsSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
//            NSLog(@"push self.smallImageL5FormRowsSlideViewController: %@", self.smallImageL5FormRowsSlideViewController);
        }];
    }    
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

- (void)toggleSmallImageL5FormRowsSlideViewProcessCenter4ScrollView {
//    NSLog(@"inner entered");
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.smallImageL5FormRowsSlideViewController.view setFrame:slideUpViewFrame];
    } completion:^(BOOL finished){
        [self clearSmallImageL5FormRowsSlideViewController];
    }];
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

#pragma mark SmallImageSlideViewItemDelegate
- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectSmallImageSlideViewItem LargeSmallImage");
    NSMutableDictionary* descrDetailDict = [self.smallImageL5FormRowsSlideViewController.smallImageL5FormRowsDataManager.displayList objectAtIndex:anIndexPathRow];
    [self showProductViewWithL5Dict:descrDetailDict];    
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)clearSmallImageL5FormRowsSlideViewController {
//    NSLog(@"clearSmallImageL5FormRowsSlideViewController");
//    NSLog(@"smallImageL5FormRowsSlideViewController.view removeFromSuperview");
    self.smallImageL5FormRowsSlideViewController.delegate = nil;
    [self.smallImageL5FormRowsSlideViewController.view removeFromSuperview];    
}

- (void)showProductViewWithL5Dict:(NSMutableDictionary*)aL5DescrDetailDict {
    NSString* descrDetailCode = [aL5DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* unsortFormRows = [NSMutableArray array];
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL5Code:descrDetailCode];
    if (products != nil && [products count] > 0) {
        for (NSMutableDictionary* product in products) {
            //            NSMutableDictionary* formRow = [self createFormRowWithProduct:product];
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product];
            //sync the row with current cart
            formRow = [[OrderSharedClass sharedOrderSharedClass] syncRowWithCurrentCart:formRow];
            
            [unsortFormRows addObject:formRow];
        }
//        NSLog(@"%d form rows created from L5 code %@", [unsortFormRows count], descrDetailCode);
        //push the form row view if there are some rows
        if ([unsortFormRows count] > 0) {
            FormRowsTableViewController* formRowsView = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
            formRowsView.dividerIUR = [NSNumber numberWithInt:-2];//dirty fit the form row
            
            formRowsView.isShowingSearchBar = YES;
            formRowsView.title = [aL5DescrDetailDict objectForKey:@"Detail"];
            formRowsView.unsortedFormrows = unsortFormRows;
            [formRowsView syncUnsortedFormRowsWithOriginal];
            
            [self.navigationController pushViewController:formRowsView animated:YES];
            [formRowsView release];
        }else{
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"No product found in the current selected form." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
            actionSheet.tag = 0;
            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.parentViewController.view];
            [actionSheet release];
            return;
        }
    } else {
        [ArcosUtils showMsg:@"No data found" delegate:nil];
    }
}

- (void)clearLargeSmallImageFormRowsSlideViewContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLISVIC == [NSNull null]) {
        return;
    }
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}

- (void)loadLargeSmallImageSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallImageFormRowsDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC != [NSNull null]) {
        return;
    }
    LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
    
    [self.largeSmallImageFormRowsDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LISVIC];
    [LISVIC release];
    
    LISVIC.delegate = self;
    LISVIC.indexPathRow = aPageIndex;
    [self.myScrollView addSubview:LISVIC.view];
    [self.largeSmallImageFormRowsDataManager fillLargeSmallImageSlideViewItemWithIndex:aPageIndex];
}

- (void)unloadLargeSmallImageSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallImageFormRowsDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC == [NSNull null]) {
        return;
    }
    [self clearLargeSmallImageFormRowsSlideViewContentWithIndex:aPageIndex];
    [self.largeSmallImageFormRowsDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}

- (void)loadBufferLargeSmallImageSlideViewItem {
    for (int i = self.largeSmallImageFormRowsDataManager.currentPage - self.largeSmallImageFormRowsDataManager.halfBufferSize; i <= self.largeSmallImageFormRowsDataManager.currentPage + self.largeSmallImageFormRowsDataManager.halfBufferSize; i++) {
        [self loadLargeSmallImageSlideViewItemWithIndex:i];
    }
}

- (void)unloadNotBufferLargeSmallImageSlideViewItem {
    for (int i = 0; i < self.largeSmallImageFormRowsDataManager.currentPage - self.largeSmallImageFormRowsDataManager.halfBufferSize; i++) {
        [self unloadLargeSmallImageSlideViewItemWithIndex:i];
    }
    for (int j = self.largeSmallImageFormRowsDataManager.currentPage + self.largeSmallImageFormRowsDataManager.halfBufferSize + 1; j < [self.largeSmallImageFormRowsDataManager.slideViewItemList count]; j++) {
        [self unloadLargeSmallImageSlideViewItemWithIndex:j];
    }
}

- (void)countValidLargeSmallImageSlideViewItem {
    int count = 0;
    for (int i = 0; i < [self.largeSmallImageFormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallImageFormRowsDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLISVIC != [NSNull null]) {
            count++;
            NSLog(@"valid index: %d",i);
        }
    }
    NSLog(@"currentpage: %d total count: %d",self.largeSmallImageFormRowsDataManager.currentPage, count);
}

@end
