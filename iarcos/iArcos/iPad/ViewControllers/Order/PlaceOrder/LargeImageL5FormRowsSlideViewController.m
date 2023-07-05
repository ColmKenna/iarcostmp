//
//  LargeImageL5FormRowsSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeImageL5FormRowsSlideViewController.h"
@interface LargeImageL5FormRowsSlideViewController ()
- (void)alignSubviews;
- (void)loadLargeImageL5SlideViewItemWithIndex:(int)aPageIndex;
- (void)unloadLargeImageL5SlideViewItemWithIndex:(int)aPageIndex;
- (void)clearLargeImageL5SlideViewItemContentWithIndex:(int)aPageIndex;
- (void)countValidLargeImageL5SlideViewItem;
- (void)loadAllLargeImageL5SlideViewItem;
@end

@implementation LargeImageL5FormRowsSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize largeImageL5FormRowsDataManager = _largeImageL5FormRowsDataManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.largeImageL5FormRowsDataManager = [[[LargeImageL5FormRowsDataManager alloc] init] autorelease];
        
    }
    return self;
}


- (void)dealloc
{
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.largeImageL5FormRowsDataManager != nil) { self.largeImageL5FormRowsDataManager = nil; }    
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"viewWillAppear largeimagel5");
//    NSLog(@"currentPage is: %d", self.largeImageL5FormRowsDataManager.currentPage);
    
    [super viewWillAppear:animated];
    [self.largeImageL5FormRowsDataManager createPlaceholderLargeImageL5SlideViewItemData];    
    [self loadAllLargeImageL5SlideViewItem];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeImageL5FormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);       
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear largeimagel5");
    [super viewDidAppear:animated];
    
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeImageL5FormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"viewWillDisappear largeimagel5");
    [super viewWillDisappear:animated];    
}

- (void)viewDidDisappear:(BOOL)animated
{
//    NSLog(@"viewDidDisappear largeimagel5");
    [super viewDidDisappear:animated];
    for (int i = 0; i < [self.largeImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        [self clearLargeImageL5SlideViewItemContentWithIndex:i];
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
	self.myScrollView.contentOffset = CGPointMake(self.largeImageL5FormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{    
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}
   

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {   
    self.largeImageL5FormRowsDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    if (self.largeImageL5FormRowsDataManager.currentPage != self.largeImageL5FormRowsDataManager.previousPage) {
//        NSLog(@"EndDecelerating load");
        self.largeImageL5FormRowsDataManager.previousPage = self.largeImageL5FormRowsDataManager.currentPage;
        [self loadAllLargeImageL5SlideViewItem];
        [self unloadLargeImageL5SlideViewItemWithIndex:self.largeImageL5FormRowsDataManager.currentPage - 3];
        [self unloadLargeImageL5SlideViewItemWithIndex:self.largeImageL5FormRowsDataManager.currentPage - 4];
        [self unloadLargeImageL5SlideViewItemWithIndex:self.largeImageL5FormRowsDataManager.currentPage + 3];
        [self unloadLargeImageL5SlideViewItemWithIndex:self.largeImageL5FormRowsDataManager.currentPage + 4];
    }
     
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeImageL5FormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);     
//    [self countValidLargeImageL5SlideViewItem];
     
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.largeImageL5FormRowsDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.largeImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeImageL5FormRowsDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)aLISVIC == [NSNull null]) {
        } else {
            aLISVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
        }        
    }
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectLargeImageSlideViewItem: %d", anIndexPathRow);
    NSMutableDictionary* descrDetailDict = [self.largeImageL5FormRowsDataManager.displayList objectAtIndex:anIndexPathRow];
    NSString* descrDetailCode = [descrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* unsortFormRows = [NSMutableArray array];
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL5Code:descrDetailCode];
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
            formRowsView.title = [descrDetailDict objectForKey:@"Detail"];
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

- (void)loadLargeImageL5SlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeImageL5FormRowsDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeImageL5FormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC != [NSNull null]) {
        return;
    }
    LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
    
    [self.largeImageL5FormRowsDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:LISVIC];
    [LISVIC release];
    
    LISVIC.delegate = self;
    LISVIC.indexPathRow = aPageIndex;
    [self.myScrollView addSubview:LISVIC.view];
    [self.largeImageL5FormRowsDataManager fillLargeImageL5SlideViewItemWithIndex:aPageIndex];
}

- (void)unloadLargeImageL5SlideViewItemWithIndex:(int)aPageIndex {
    if (aPageIndex < 0 || aPageIndex >= [self.largeImageL5FormRowsDataManager.displayList count]) {
        return;
    }
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeImageL5FormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)aLISVIC == [NSNull null]) {
        return;
    }
    [self clearLargeImageL5SlideViewItemContentWithIndex:aPageIndex];
    [self.largeImageL5FormRowsDataManager.slideViewItemList replaceObjectAtIndex:aPageIndex withObject:[NSNull null]];
}


- (void)clearLargeImageL5SlideViewItemContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeImageL5FormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];
    if ((NSNull *)tmpLISVIC == [NSNull null]) {
//        NSLog(@"clearLargeImageL5SlideViewItemContentWithIndex encounter null");
        return;
    }
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}

- (void)countValidLargeImageL5SlideViewItem {
    int count = 0;
    for (int i = 0; i < [self.largeImageL5FormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeImageL5FormRowsDataManager.slideViewItemList objectAtIndex:i];
        if ((NSNull *)tmpLISVIC != [NSNull null]) {
            count++;
            NSLog(@"valid index: %d",i);
        }
    }
    NSLog(@"total count: %d", count);
}

- (void)loadAllLargeImageL5SlideViewItem {
    for (int i = self.largeImageL5FormRowsDataManager.currentPage - 2; i <= self.largeImageL5FormRowsDataManager.currentPage + 2; i++) {
        [self loadLargeImageL5SlideViewItemWithIndex:i];
    }
}

@end
