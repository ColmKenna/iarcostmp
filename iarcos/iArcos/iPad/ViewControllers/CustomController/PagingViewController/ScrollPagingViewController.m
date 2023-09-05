//
//  ScrollPagingViewController.m
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "ScrollPagingViewController.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "FormRowsTableViewController.h"
#import "SettingManager.h"
@interface ScrollPagingViewController (Private)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)resetScrollViewSize;
- (void)initControllers;
-(void)selectPage:(int)pageNumber;
-(void)removeAllPages;
-(void)repositionPages;
-(void)removePage:(int)page;
-(void)saveOrderToTheCart:(NSMutableDictionary*)data;
@end

@implementation ScrollPagingViewController
@synthesize scrollView, viewControllers,filesArray;
@synthesize theData;
@synthesize factory;
@synthesize groupType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.filesArray=[NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [viewControllers release];
    [scrollView release];
    [pageControl release];
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
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    //add order button to the navigation bar
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Order"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(orderProduct:)];
    
    self.navigationItem.rightBarButtonItem = typeButton;
    [typeButton release];
    
    //scrolling view init
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor=[UIColor whiteColor];

    UIInterfaceOrientation or=[UIApplication sharedApplication].statusBarOrientation;
    if (or== UIInterfaceOrientationPortrait||or==UIInterfaceOrientationPortraitUpsideDown) {
        //self.view.frame=CGRectMake(0, 0, 768, 911);
    }
    
    [self resetScrollViewSize];
    
    //input popover
    factory=[WidgetFactory factory];
    factory.delegate=self;
//    inputPopover=[factory CreateOrderInputPadWidgetWithLocationIUR:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
//    [inputPopover dismissPopoverAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)||orientation==0) {
        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)initControllers{
    [self removeAllPages];

    if ([self.filesArray count]<=0) {
        return;
    }
    //prepopulate the controllers
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.filesArray count]; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
    
    [self resetScrollViewSize];
    
    pageControl.numberOfPages = [filesArray count];
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
//    [self loadScrollViewWithPage:0];
//    [self loadScrollViewWithPage:1];
}
-(void)selectPage:(int)pageNumber{
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:pageNumber - 1];
    [self loadScrollViewWithPage:pageNumber];
    [self loadScrollViewWithPage:pageNumber + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    pageControl.currentPage=pageNumber;
}
- (void)resetScrollViewSize{
    // a page is the width of the scroll view
    self.scrollView.frame=self.view.frame;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [filesArray count], scrollView.frame.size.height);
}
-(void)resetResource:(NSMutableArray*)resource WithGrouType:(NSString*)type{
    NSLog(@"resurce for scrolling pageing view is %@",resource);
    self.groupType=type;
    
    self.filesArray=resource;
    [self initControllers];
    if ([self.filesArray count]>0) {
        [self selectPage:0];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)resetResource:(NSMutableArray*)resource{
    NSLog(@"resurce for scrolling pageing view is %@",resource);
    
    self.filesArray=resource;

}
- (void)loadScrollViewWithPage:(int)page {
    if (page < 0||[viewControllers count]<=0) return;
    if (page >= [filesArray count]) return;
	
    // replace the placeholder if necessary
    WebPagingViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        
        NSMutableDictionary* fileDict=[self.filesArray objectAtIndex:page];
        NSString* fileName=[fileDict objectForKey:@"Name"];
        NSString* presenterPath=[FileCommon presenterPath];
        NSString* fullPath=[NSString stringWithFormat:@"%@/%@",presenterPath,fileName];
        NSString* fileType=[fileDict objectForKey:@"Type"];
        NSLog(@"path to local file %@",fullPath);
        controller = [[WebPagingViewController alloc] initWithPath:fullPath withName:fileName];
        controller.downloadFolder=@"presenter";
        controller.downloadServer=[SettingManager downloadServer];
        controller.fileType=fileType;
        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}
-(void)removePage:(int)page{
    if (page < 0) return;
    if (page >= [filesArray count]) return;
    if (page >=[self.viewControllers count]) return;
    
    if ([self.viewControllers objectAtIndex:page]!=[NSNull null]) {
        WebPagingViewController* vc=(WebPagingViewController*)[self.viewControllers objectAtIndex:page];
        [vc.view removeFromSuperview];
        //[vc.theWebView loadHTMLString:@"about:blank" baseURL:nil];
        //[vc release];
        //[self.viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
        
        //NSLog(@"remove page %d",page);

    }
}
-(void)removeAllPages{
    // add the controller's view to the scroll view
    if (self.viewControllers==nil || [self.viewControllers count]<=0) {
        return;
    }
    for (WebPagingViewController* vc in self.viewControllers) {
        
        if ( (NSNull *)vc != [NSNull null]) {
            vc.fc.delegate=self;
            vc.theWebView.delegate=self;
            if (vc.view !=nil) {
                if (vc.view.superview !=nil) {
                    [vc.view removeFromSuperview];
                    [vc.theWebView loadHTMLString:@"about:blank" baseURL:nil];
                    //[vc release];
                }
            }
        }
    }
    [self.viewControllers removeAllObjects];
    [self resetScrollViewSize];
    currentPageNum=0;
}
-(void)repositionPages{
    [self resetScrollViewSize];
    for (int i=0; i<[self.viewControllers count]; i++) {
        if ([self.viewControllers objectAtIndex:i]!=[NSNull null]) {
            UIViewController* vc=(UIViewController*)[self.viewControllers objectAtIndex:i];
            if (vc.view.superview !=nil) {
                CGRect frame = scrollView.frame;
                frame.origin.x = frame.size.width * i;
                frame.origin.y = 0;
                vc.view.frame = frame;
            }
        }
    }
}
#pragma mark scorlling view delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    currentPageNum=page;
    //NSLog(@"page changed to %d",currentPageNum);
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
    //NSLog(@"currently on page %d",page);
    //remove the invisiable page
    if ((page-2)>=0) {
        [self removePage:page-2];
    }
    if ((page+2)<[filesArray count]) {
        [self removePage:page+2];
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = [ArcosUtils convertNSIntegerToInt:pageControl.currentPage];
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration {
    pageControlUsed=YES;

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    
    [self repositionPages];
    //[self selectPage:currentPageNum];
	scrollView.contentOffset = CGPointMake(currentPageNum * scrollView.frame.size.width, 0);
    //NSLog(@"page number is %d",currentPageNum);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    pageControlUsed=NO;

}

//split view bar item
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:NO];

}

#pragma mark order product
//order product
-(void)orderProduct:(id)sender{
    UIBarButtonItem* button=(UIBarButtonItem*)sender;
    
    //check any customer 
    if ([GlobalSharedClass shared].currentSelectedLocationIUR ==nil){     
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No Customer selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        actionSheet.tag=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.parentViewController.view];
        [actionSheet release];
        return;
    }
    //no form
    if (![[OrderSharedClass sharedOrderSharedClass]anyForm]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No Form selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        actionSheet.tag=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.parentViewController.view];
        [actionSheet release];
        return;
    }

    //check any files
    if ([self.filesArray count]>0) {
        self.theData=[self.filesArray objectAtIndex:currentPageNum];
    }else{
        return;
    }

    
    
    //order the product
    NSLog(@"order pressed! with data %@",self.theData);
    if(self.theData != nil){
        NSString* L5code=[self.theData objectForKey:@"L5code"];
        NSNumber* ProductIUR=[self.theData objectForKey:@"ProductIUR"];
        
        //single product
        if ([ProductIUR intValue]>0&&![L5code isEqualToString:@""]&&L5code!=nil) {
            NSMutableDictionary* formRow=[NSMutableDictionary dictionary];

            BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
            
            //check is product already in the current selected form
            if (!isProductInCurrentForm) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Product is not in current selected form!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                actionSheet.tag=0;
                actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [actionSheet showInView:self.parentViewController.view];
                [actionSheet release];
                return;
            }
            
            NSLog(@"get only one product!");
//            formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            NSLog(@"form row for the product is %@",formRow);
            
            //sync the row with current cart
            formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
            //[[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:formRow];
            
//            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) inputPopover.contentViewController;
//            oipvc.Data=formRow;
//
//            [inputPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else if(![L5code isEqualToString:@""]&&[ProductIUR intValue]<=0){//product group
            //NSMutableDictionary* formRows=[NSMutableDictionary dictionary];
            NSMutableArray* unsortFormRows=[NSMutableArray array];
            NSMutableArray* products=[[ArcosCoreData sharedArcosCoreData]productWithL5Code:L5code];
//            NSLog(@"get %d products from whole group!",[products count]);

            if (products!=nil&&[products count]>0) {//any product for the given L5 code
                for (NSMutableDictionary* aProduct in products) {//loop products
                    NSNumber* ProductIUR=[aProduct objectForKey:@"ProductIUR"];
                    //is the product int the current form
                    BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
                    
                    if (isProductInCurrentForm) {//create a form row and add to the form rows array
//                        NSMutableDictionary* formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
                        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
                        //sync the row with current cart
                        formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
                        //[[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:formRow];

                        
                        //[formRows setObject:formRow forKey:[formRow objectForKey:@"CombinationKey"]];
                        [unsortFormRows addObject:formRow];

                    }
                }
//                NSLog(@"%d form rows created from L5 code %@",[unsortFormRows count],L5code);
                
                //push the form row view if there are some rows
                if ([unsortFormRows count]>0) {
                    FormRowsTableViewController *formRowsView= [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
                    formRowsView.dividerIUR=[NSNumber numberWithInt:-2];//dirty fit the form row
                    //[formRowsView resetDataWithFormRows:formRows];
                    formRowsView.unsortedFormrows=unsortFormRows;
                    [self.navigationController pushViewController:formRowsView animated:YES];
                    [formRowsView release];
                }else{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"None product is not in current selected form!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                    actionSheet.tag=0;
                    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                    [actionSheet showInView:self.parentViewController.view];
                    [actionSheet release];
                    return;
                }
                
                
            }
        }
        
    }
    

    //[inputPopover presentPopoverFromRect:button.bound inView:self. permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
//input popover delegate
-(void)operationDone:(id)data{
    NSLog(@"input is done! with value %@",data);
    
//    [inputPopover dismissPopoverAnimated:YES];
    [[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:data];
    [self saveOrderToTheCart:data];
    
}

-(void)saveOrderToTheCart:(NSMutableDictionary*)data{
    
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
}

//file common delegate
-(void)fileDownloaded:(FileCommon *)fileCommon withError:(BOOL)anyError{
    NSLog(@"%@ is download delegate in scroll pageing view",fileCommon.fileName);
    
}
//web delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"content loaded via delegate in scroll pageing view!");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"content load with error %@",[error description]);
}
@end
