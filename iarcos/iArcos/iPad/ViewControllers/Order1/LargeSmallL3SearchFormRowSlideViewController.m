//
//  LargeSmallL3SearchFormRowSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallL3SearchFormRowSlideViewController.h"
@interface LargeSmallL3SearchFormRowSlideViewController ()
- (void)alignSubviews;
- (void)createSmallL5L3SearchFormRowsSlideViewController:(int)anIndexPathRow;
- (void)toggleSmallL5L3SearchFormRowsSlideView:(int)anIndexPathRow;
- (void)toggleSmallL5L3SearchFormRowsSlideViewProcessCenter;
- (void)clearSmallL5L3SearchFormRowsSlideViewController;
- (void)toggleSmallL5L3SearchFormRowsSlideViewProcessCenter4ScrollView;
- (void)showProductViewWithL5Dict:(NSMutableDictionary*)aL5DescrDetailDict l3Code:(NSString*)anL3Code;
- (void)clearLargeSmallL3SearchFormRowsSlideViewContentWithIndex:(int)aPageIndex;
- (void)loadLargeSmallL3SearchSlideViewItemWithIndex:(int)aPageIndex;
- (void)unloadLargeSmallL3SearchSlideViewItemWithIndex:(int)aPageIndex;
- (void)loadBufferLargeSmallL3SearchSlideViewItem;
- (void)unloadNotBufferLargeSmallL3SearchSlideViewItem;
- (void)countValidLargeSmallL3SearchSlideViewItem;
@end

@implementation LargeSmallL3SearchFormRowSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize largeSmallL3SearchFormRowDataManager = _largeSmallL3SearchFormRowDataManager;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize smallL5L3SearchFormRowSlideViewController = _smallL5L3SearchFormRowSlideViewController;
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
    if (self.largeSmallL3SearchFormRowDataManager != nil) { self.largeSmallL3SearchFormRowDataManager = nil; }
    if (self.backButtonDelegate != nil) { self.backButtonDelegate = nil; }
    if (self.smallL5L3SearchFormRowSlideViewController != nil) { self.smallL5L3SearchFormRowSlideViewController = nil; }
    
    
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
    self.largeSmallL3SearchFormRowDataManager = [[[LargeSmallL3SearchFormRowDataManager alloc] init] autorelease];
    self.slideUpViewHeight = 177.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
            
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
    //    NSLog(@"viewWillAppear largeimageformrows");
    [super viewWillAppear:animated];
    if (!self.isNotFirstLoaded) {
        [self.largeSmallL3SearchFormRowDataManager getLevel3DescrDetail];
        self.isNotFirstLoaded = YES;
    }
    
    /*
    [self.largeSmallL3SearchFormRowDataManager createLargeSmallL3SearchSlideViewItemData];
    for (int i = 0; i < [self.largeSmallL3SearchFormRowDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:i];
        aLISVIC.delegate = self;
        aLISVIC.indexPathRow = i;
        [self.myScrollView addSubview:aLISVIC.view];
        [self.largeSmallL3SearchFormRowDataManager fillLargeSmallL3SearchSlideViewItemWithIndex:i];
    }
    */
    [self.largeSmallL3SearchFormRowDataManager createPlaceholderLargeSmallL3SearchSlideViewItemData];
    [self loadBufferLargeSmallL3SearchSlideViewItem];
    if (self.isSlideUpViewShowing) {
        self.smallL5L3SearchFormRowSlideViewController.delegate = self;
        [self.view addSubview:self.smallL5L3SearchFormRowSlideViewController.view];
        [self.smallL5L3SearchFormRowSlideViewController viewWillAppear:YES];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallL3SearchFormRowDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLargeSmallL3SearchSlideViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    //    NSLog(@"viewDidAppear largeimageformrows");
    [super viewDidAppear:animated];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallL3SearchFormRowDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    NSLog(@"viewWillDisappear largeimageformrows");    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //    NSLog(@"viewDidDisappear largeimageformrows");    
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.largeSmallL3SearchFormRowDataManager.slideViewItemList count]; i++) {
        [self clearLargeSmallL3SearchFormRowsSlideViewContentWithIndex:i];
    }
    if (self.isSlideUpViewShowing) {
        self.smallL5L3SearchFormRowSlideViewController.delegate = nil;
        [self.smallL5L3SearchFormRowSlideViewController.view removeFromSuperview];
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
	self.myScrollView.contentOffset = CGPointMake(self.largeSmallL3SearchFormRowDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.largeSmallL3SearchFormRowDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.largeSmallL3SearchFormRowDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:i];
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
        self.smallL5L3SearchFormRowSlideViewController.view.frame = slideUpViewFrame;        
    }
}

- (void)createSmallL5L3SearchFormRowsSlideViewController:(int)anIndexPathRow {
    NSMutableDictionary* l3DescrDetailDict = [self.largeSmallL3SearchFormRowDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* l3DescrDetailCode = [l3DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l3DescrDetailDict objectForKey:@"L5Children"];
//    NSLog(@"l5ChildrenList count: %d", [l5ChildrenList count]);
    if ([l5ChildrenList count] > 1) {
        self.smallL5L3SearchFormRowSlideViewController = [[[SmallL5L3SearchFormRowSlideViewController alloc] initWithNibName:@"SmallL5L3SearchFormRowSlideViewController" bundle:nil] autorelease];
        self.smallL5L3SearchFormRowSlideViewController.delegate = self;
        self.smallL5L3SearchFormRowSlideViewController.smallL5L3SearchFormRowDataManager.currentIndexPathRow = anIndexPathRow;
        self.smallL5L3SearchFormRowSlideViewController.smallL5L3SearchFormRowDataManager.l3DescrDetailCode = [NSString stringWithFormat:@"%@",l3DescrDetailCode];
        self.smallL5L3SearchFormRowSlideViewController.smallL5L3SearchFormRowDataManager.displayList = [NSMutableArray arrayWithArray:l5ChildrenList];
        CGRect myScrollViewBounds = self.myScrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        self.smallL5L3SearchFormRowSlideViewController.view.frame = slideUpViewFrame;
        [self.view addSubview:self.smallL5L3SearchFormRowSlideViewController.view];
    }
    
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
    //    NSLog(@"didSelectLargeSmallImageSlideViewItem: %d", anIndexPathRow);
    NSMutableDictionary* l3DescrDetailDict = [self.largeSmallL3SearchFormRowDataManager.displayList objectAtIndex:anIndexPathRow];
//    NSLog(@"l3DescrDetailDict: %@", l3DescrDetailDict);
    NSString* l3DescrDetailCode = [l3DescrDetailDict objectForKey:@"DescrDetailCode"]; 
    NSMutableArray* l5ChildrenList = [l3DescrDetailDict objectForKey:@"L5Children"];
    if ([l5ChildrenList count] == 1) {
        [self showProductViewWithL5Dict:[l5ChildrenList objectAtIndex:0] l3Code:l3DescrDetailCode];
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    } else {
        [self toggleSmallL5L3SearchFormRowsSlideView:anIndexPathRow];
    }
}

- (void)toggleSmallL5L3SearchFormRowsSlideView:(int)anIndexPathRow {
    if (!self.isSlideUpViewShowing) {
        [self createSmallL5L3SearchFormRowsSlideViewController:anIndexPathRow];
    }    
    [self toggleSmallL5L3SearchFormRowsSlideViewProcessCenter];
}

- (void)toggleSmallL5L3SearchFormRowsSlideViewProcessCenter {
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
            [self.smallL5L3SearchFormRowSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            [self clearSmallL5L3SearchFormRowsSlideViewController];
            //            NSLog(@"pop self.smallImageL5FormRowsSlideViewController: %@", self.smallImageL5FormRowsSlideViewController);
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.smallL5L3SearchFormRowSlideViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            //            NSLog(@"push self.smallImageL5FormRowsSlideViewController: %@", self.smallImageL5FormRowsSlideViewController);
        }];
    }    
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

- (void)toggleSmallL5L3SearchFormRowsSlideViewProcessCenter4ScrollView {
    //    NSLog(@"inner entered");
    CGRect myScrollViewBounds = self.myScrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    if (self.isSlideUpViewShowing) {
        slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
    } else {
        slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.smallL5L3SearchFormRowSlideViewController.view setFrame:slideUpViewFrame];
    } completion:^(BOOL finished){
        [self clearSmallL5L3SearchFormRowsSlideViewController];
    }];
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{    
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {    
    self.largeSmallL3SearchFormRowDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.isSlideUpViewShowing && self.largeSmallL3SearchFormRowDataManager.currentPage != self.largeSmallL3SearchFormRowDataManager.previousPage) {
        [self toggleSmallL5L3SearchFormRowsSlideViewProcessCenter4ScrollView];
    }
    if (self.largeSmallL3SearchFormRowDataManager.currentPage != self.largeSmallL3SearchFormRowDataManager.previousPage) {
        self.largeSmallL3SearchFormRowDataManager.previousPage = self.largeSmallL3SearchFormRowDataManager.currentPage;
        [self loadBufferLargeSmallL3SearchSlideViewItem];
        [self unloadNotBufferLargeSmallL3SearchSlideViewItem];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeSmallL3SearchFormRowDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
//    [self countValidLargeSmallL3SearchSlideViewItem];
}

#pragma mark SmallImageSlideViewItemDelegate
- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow {
    //    NSLog(@"didSelectSmallImageSlideViewItem LargeSmallImage");
    NSMutableDictionary* descrDetailDict = [self.smallL5L3SearchFormRowSlideViewController.smallL5L3SearchFormRowDataManager.displayList objectAtIndex:anIndexPathRow];
    [self showProductViewWithL5Dict:descrDetailDict l3Code:self.smallL5L3SearchFormRowSlideViewController.smallL5L3SearchFormRowDataManager.l3DescrDetailCode];    
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)clearSmallL5L3SearchFormRowsSlideViewController {
    self.smallL5L3SearchFormRowSlideViewController.delegate = nil;
    [self.smallL5L3SearchFormRowSlideViewController.view removeFromSuperview];    
}

- (void)showProductViewWithL5Dict:(NSMutableDictionary*)aL5DescrDetailDict l3Code:(NSString *)anL3Code {
    NSString* descrDetailCode = [aL5DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* unsortFormRows = [NSMutableArray array];
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL3Code:anL3Code l5Code:descrDetailCode];
    if (products != nil && [products count] > 0) {
        NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[currentFormDetailDict objectForKey:@"Details"]];
        for (NSMutableDictionary* product in products) {
            //            NSMutableDictionary* formRow = [self createFormRowWithProduct:product];
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product orderFormDetails:orderFormDetails];
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

- (void)clearLargeSmallL3SearchFormRowsSlideViewContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLISVIC == [NSNull null]) {
        return;
    }
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}

- (void)loadLargeSmallL3SearchSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallL3SearchFormRowDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC != [NSNull null]) {
        return;
    }
    LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
    
    [self.largeSmallL3SearchFormRowDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LISVIC];
    [LISVIC release];
    
    LISVIC.delegate = self;
    LISVIC.indexPathRow = aPageIndex;
    [self.myScrollView addSubview:LISVIC.view];
    [self.largeSmallL3SearchFormRowDataManager fillLargeSmallL3SearchSlideViewItemWithIndex:aPageIndex];
}

- (void)unloadLargeSmallL3SearchSlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeSmallL3SearchFormRowDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC == [NSNull null]) {
        return;
    }
    [self clearLargeSmallL3SearchFormRowsSlideViewContentWithIndex:aPageIndex];
    [self.largeSmallL3SearchFormRowDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}

- (void)loadBufferLargeSmallL3SearchSlideViewItem {
    for (int i = self.largeSmallL3SearchFormRowDataManager.currentPage - self.largeSmallL3SearchFormRowDataManager.halfBufferSize; i <= self.largeSmallL3SearchFormRowDataManager.currentPage + self.largeSmallL3SearchFormRowDataManager.halfBufferSize; i++) {
        [self loadLargeSmallL3SearchSlideViewItemWithIndex:i];
    }
}

- (void)unloadNotBufferLargeSmallL3SearchSlideViewItem {
    for (int i = 0; i < self.largeSmallL3SearchFormRowDataManager.currentPage - self.largeSmallL3SearchFormRowDataManager.halfBufferSize; i++) {
        [self unloadLargeSmallL3SearchSlideViewItemWithIndex:i];
    }
    for (int j = self.largeSmallL3SearchFormRowDataManager.currentPage + self.largeSmallL3SearchFormRowDataManager.halfBufferSize + 1; j < [self.largeSmallL3SearchFormRowDataManager.slideViewItemList count]; j++) {
        [self unloadLargeSmallL3SearchSlideViewItemWithIndex:j];
    }
}

- (void)countValidLargeSmallL3SearchSlideViewItem {
    int count = 0;
    for (int i = 0; i < [self.largeSmallL3SearchFormRowDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeSmallL3SearchFormRowDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLISVIC != [NSNull null]) {
            count++;
            NSLog(@"valid index: %d",i);
        }
    }
    NSLog(@"currentpage: %d total count: %d",self.largeSmallL3SearchFormRowDataManager.currentPage, count);
}

@end
