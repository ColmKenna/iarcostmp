//
//  LargeImageFormRowsSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeImageFormRowsSlideViewController.h"
@interface LargeImageFormRowsSlideViewController ()
- (void)alignSubviews;
- (void)clearLargeImageFormRowsSlideViewContentWithIndex:(int)aPageIndex;
@end

@implementation LargeImageFormRowsSlideViewController
@synthesize myScrollView = _myScrollView;
@synthesize largeImageFormRowsDataManager = _largeImageFormRowsDataManager;
@synthesize backButtonDelegate = _backButtonDelegate;

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
    if (self.largeImageFormRowsDataManager != nil) { self.largeImageFormRowsDataManager = nil; }
    if (self.backButtonDelegate != nil) { self.backButtonDelegate = nil; }
    
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
    self.largeImageFormRowsDataManager = [[[LargeImageFormRowsDataManager alloc] init] autorelease];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"viewWillAppear largeimageformrows");
    [super viewWillAppear:animated];    
    [self.largeImageFormRowsDataManager getLevel4DescrDetail];
    [self.largeImageFormRowsDataManager createLargeImageSlideViewItemData];
    for (int i = 0; i < [self.largeImageFormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeImageFormRowsDataManager.slideViewItemList objectAtIndex:i];
        aLISVIC.delegate = self;
        aLISVIC.indexPathRow = i;
        [self.myScrollView addSubview:aLISVIC.view];
        [self.largeImageFormRowsDataManager fillLargeImageSlideViewItemWithIndex:i];
    }
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear largeimageformrows");
    [super viewDidAppear:animated];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.largeImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);    
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
    for (int i = 0; i < [self.largeImageFormRowsDataManager.slideViewItemList count]; i++) {
        [self clearLargeImageFormRowsSlideViewContentWithIndex:i];
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
	self.myScrollView.contentOffset = CGPointMake(self.largeImageFormRowsDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.largeImageFormRowsDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.largeImageFormRowsDataManager.slideViewItemList count]; i++) {
        LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.largeImageFormRowsDataManager.slideViewItemList objectAtIndex:i];
        aLISVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
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
    self.largeImageFormRowsDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
}

#pragma mark LargeImageSlideViewItemDelegate
- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow {
//    NSLog(@"didSelectLargeImageSlideViewItem: %d", anIndexPathRow);
    NSMutableDictionary* l4DescrDetailDict = [self.largeImageFormRowsDataManager.displayList objectAtIndex:anIndexPathRow];
    //    NSLog(@"descrDetailDict DescrDetailCode is %@ %@", [descrDetailDict objectForKey:@"DescrDetailCode"], descrDetailDict);
    NSString* l4DescrDetailCode = [l4DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l4DescrDetailDict objectForKey:@"L5Children"];
    //    NSLog(@"l5ChildrenList count: %d", [l5ChildrenList count]);
    if ([l5ChildrenList count] > 1) {
        LargeImageL5FormRowsSlideViewController* lil5frsvc = [[LargeImageL5FormRowsSlideViewController alloc] initWithNibName:@"LargeImageL5FormRowsSlideViewController" bundle:nil];
        lil5frsvc.title = [l4DescrDetailDict objectForKey:@"Detail"];       
        lil5frsvc.largeImageL5FormRowsDataManager.descrDetailCode = l4DescrDetailCode;
        lil5frsvc.largeImageL5FormRowsDataManager.displayList = l5ChildrenList;
        
        [self.navigationController pushViewController:lil5frsvc animated:YES];
        [lil5frsvc release];
    }
    if ([l5ChildrenList count] == 1) {
        NSMutableDictionary* l5DescrDetailDict = [l5ChildrenList objectAtIndex:0];
        NSString* l5DescrDetailCode = [l5DescrDetailDict objectForKey:@"DescrDetailCode"];
        NSMutableArray* unsortFormRows = [NSMutableArray array];
        NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL5Code:l5DescrDetailCode];
        if (products != nil && [products count] > 0) {
            NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
            NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[currentFormDetailDict objectForKey:@"Details"]];
            for (NSMutableDictionary* product in products) {
                NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product orderFormDetails:orderFormDetails];
                //sync the row with current cart
                formRow = [[OrderSharedClass sharedOrderSharedClass] syncRowWithCurrentCart:formRow];
                
                [unsortFormRows addObject:formRow];
            }
//            NSLog(@"%d form rows created from L5 code %@", [unsortFormRows count], l5DescrDetailCode);
            //push the form row view if there are some rows
            if ([unsortFormRows count] > 0) {
                FormRowsTableViewController* formRowsView = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
                formRowsView.dividerIUR = [NSNumber numberWithInt:-2];//dirty fit the form row
                formRowsView.isShowingSearchBar = YES;
                formRowsView.title = [l4DescrDetailDict objectForKey:@"Detail"];
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
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
    
}

- (void)clearLargeImageFormRowsSlideViewContentWithIndex:(int)aPageIndex {
    LargeImageSlideViewItemController* tmpLISVIC = (LargeImageSlideViewItemController*)[self.largeImageFormRowsDataManager.slideViewItemList objectAtIndex:aPageIndex];    
    [tmpLISVIC.view removeFromSuperview];
    [tmpLISVIC clearContent];
}


@end
