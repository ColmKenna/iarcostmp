//
//  PresenterCombinedSlideViewController.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "PresenterCombinedSlideViewController.h"
#import "ArcosRootViewController.h"

@interface PresenterCombinedSlideViewController ()
- (void)alignSubviewsWillAppear;
- (void)alignSubviews;
- (void)resetCombinedBarTitleWithIndex:(int)index;
- (void)toggleLeafSmallTemplateViewController;
- (void)addLeafSmallTemplateView;
- (void)removeLeafSmallTemplateView;
- (void)toggleLeafSmallTemplateViewProcessor;
- (void)refreshVideoItemController;
- (void)refreshPdfItemController;
@end

@implementation PresenterCombinedSlideViewController

@synthesize scrollView = _scrollView;
@synthesize currentPage = _currentPage;
@synthesize previousPage = _previousPage;
@synthesize viewItemControllerList = _viewItemControllerList;
@synthesize slideUpViewHeight = _slideUpViewHeight;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize leafSmallTemplateViewController = _leafSmallTemplateViewController;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize emailAllBarButton = _emailAllBarButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter.delegate = self;
        self.currentPage = 0;
        self.leafSmallTemplateViewController = [[[LeafSmallTemplateViewController alloc] initWithNibName:@"LeafSmallTemplateViewController" bundle:nil] autorelease];
        self.leafSmallTemplateViewController.delegate = self;
        [self addChildViewController:self.leafSmallTemplateViewController];
        [self.leafSmallTemplateViewController didMoveToParentViewController:self];
    }
    return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up some colorful content views
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    self.viewItemControllerList = [NSMutableArray array];
    //assign current file
    if ([self.files count] > 0) {
        self.currentFile=[self.files objectAtIndex:0];
//        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
        [self resetCombinedBarTitleWithIndex:self.currentPage];
        NSMutableArray* leafSmallDisplayList = [NSMutableArray arrayWithCapacity:[self.files count]];
        for (int i = 0; i < [self.files count]; i++) {
            NSDictionary* tmpDict = [self.files objectAtIndex:i];
            NSMutableDictionary* myTmpDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
            [myTmpDict setObject:[ArcosUtils convertNilToEmpty:[myTmpDict objectForKey:@"Title"]] forKey:@"Detail"];
            [leafSmallDisplayList addObject:myTmpDict];
        }
        self.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = leafSmallDisplayList;
    }
    
    for (int i = 0; i < [self.files count]; i++) {
        NSDictionary* cellDict = [self.files objectAtIndex:i];
        PresenterCombinedSlideViewBaseItemController* baseItemController = nil;
        switch ([[cellDict objectForKey:@"employeeIUR"] intValue]) {
            case 2: {
                baseItemController = [[PresenterCombinedSlideViewPdfItemController alloc]initWithNibName:@"PresenterCombinedSlideViewPdfItemController" bundle:nil];
                [self.viewItemControllerList addObject:baseItemController];
                [self addChildViewController:baseItemController];
                [self.scrollView addSubview:baseItemController.view];
                [baseItemController didMoveToParentViewController:self];
                baseItemController.itemDelegate = self;
            }
                break;
            case 6: {
                baseItemController = [[PresenterCombinedSlideViewVideoItemController alloc] initWithNibName:@"PresenterCombinedSlideViewVideoItemController" bundle:nil];
                [self.viewItemControllerList addObject:baseItemController];
                [self addChildViewController:baseItemController];
                [self.scrollView addSubview:baseItemController.view];
                [baseItemController didMoveToParentViewController:self];
                baseItemController.itemDelegate = self;
            }
                break;
            default:
                break;
        }
        
        //add file paths
        NSString* fileName = [cellDict objectForKey:@"Name"];
        NSString* filepath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        
        //if file is not exist then download it
        if ([FileCommon fileExistAtPath:filepath]) {
            [baseItemController loadContentWithPath:filepath];
        }else{
            [fileDownloadCenter addFileWithName:fileName];
            [fileDownloadCenter startDownload];
        }
        [baseItemController release];
    }
    
    [self alignSubviewsWillAppear];
    
    [self.scrollView flashScrollIndicators];
    self.slideUpViewHeight = [GlobalSharedClass shared].slideUpViewHeight;
    UIBarButtonItem* refreshBarButton = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refreshButtonPressed:)];
    self.emailAllBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email_all.png"] style:UIBarButtonItemStylePlain target:self action:@selector(emailAllBarButtonPressed:)] autorelease];
    NSMutableArray* currentRightBarButtonItemList = [NSMutableArray arrayWithArray: self.navigationItem.rightBarButtonItems];
    [currentRightBarButtonItemList addObject:refreshBarButton];
    [currentRightBarButtonItemList addObject:self.emailAllBarButton];
    self.navigationItem.rightBarButtonItems = currentRightBarButtonItemList;
    [refreshBarButton release];
}

- (BOOL)emailAllBarButtonPressed:(id)sender {
    if (![self validateHiddenPopovers]) return NO;
    [self createEmailPopoverProcessor];
//    [self.emailPopover presentPopoverFromBarButtonItem:self.emailAllBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.emailNavigationController.popoverPresentationController.barButtonItem = self.emailAllBarButton;
    self.emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.emailNavigationController animated:YES completion:nil];
    self.emailButtonAddressSelectDelegate = [[[EmailAllButtonAddressSelectDataManager alloc] initWithTarget:self] autorelease];
    return YES;
}

- (BOOL)emailButtonPressed:(id)sender {
    if (![super emailButtonPressed:sender]) return NO;
    self.emailButtonAddressSelectDelegate = [[[EmailOneButtonAddressSelectDataManager alloc] initWithTarget:self] autorelease];
    return YES;
}

- (void)refreshButtonPressed:(id)sender {
    [self refreshPdfItemController];
}

- (void)refreshPdfItemController {
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:self.currentPage];
        if ([[cellDict objectForKey:@"employeeIUR"] intValue] == 2) {
            NSString* fileName = [cellDict objectForKey:@"Name"];
            NSString* filepath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
            PresenterCombinedSlideViewPdfItemController* PCSVPIC = [self.viewItemControllerList objectAtIndex:self.currentPage];
            [PCSVPIC loadContentWithPath:filepath];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self alignSubviewsWillAppear];
    [self refreshVideoItemController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)alignSubviewsWillAppear {
    int statusBarHeight = [self retrieveStatusBarHeight];
    float tmpPageWidth = self.arcosRootViewController.selectedRightViewController.view.frame.size.width;
    float tmpPageHeight = self.arcosRootViewController.selectedRightViewController.view.frame.size.height - statusBarHeight - self.navigationController.navigationBar.frame.size.height;
    self.scrollView.contentSize = CGSizeMake([self.files count]*tmpPageWidth,
                                             tmpPageHeight);
    NSUInteger i = 0;
    for (UIViewController* myController in self.viewItemControllerList) {
        myController.view.frame = CGRectMake(i * tmpPageWidth, 0, tmpPageWidth, tmpPageHeight);
        i++;
    }
    if (self.isSlideUpViewShowing) {
        CGRect myScrollViewBounds = self.scrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        if (self.isSlideUpViewShowing) {
            slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
        } else {
            slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
        }
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
    }
}

- (void)alignSubviews {
    self.scrollView.contentSize = CGSizeMake([self.files count]*self.scrollView.bounds.size.width,
                                             self.scrollView.bounds.size.height);
    NSUInteger i = 0;
    for (UIViewController* myController in self.viewItemControllerList) {
        myController.view.frame = CGRectMake(i * self.scrollView.bounds.size.width, 0,
                             self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        i++;
    }
    if (self.isSlideUpViewShowing) {
        CGRect myScrollViewBounds = self.scrollView.bounds;
        CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
        if (self.isSlideUpViewShowing) {
            slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
        } else {
            slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
        }
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    self.currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
    self.scrollView.contentOffset = CGPointMake(self.currentPage * self.scrollView.bounds.size.width, 0);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self alignSubviews];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma scrolling view delegate
-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
    
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //pageControlUsed = NO;
    self.previousPage = self.currentPage;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //pageControlUsed = NO;
    self.currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    if (self.previousPage != self.currentPage) {
        if (self.isSlideUpViewShowing) {
            [self toggleLeafSmallTemplateViewController];
        }
        NSDictionary* cellDict = [self.files objectAtIndex:self.previousPage];
        if ([[cellDict objectForKey:@"employeeIUR"] intValue] == 6) {
            PresenterCombinedSlideViewVideoItemController* PCSVVIC = [self.viewItemControllerList objectAtIndex:self.previousPage];
            [PCSVVIC pauseVideoItemController];
        }
        [self refreshVideoItemController];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
            [self processPtranRecord:cellDict];
            self.recordBeginDate = [NSDate date];
        }
    }
    if ([self.files count] > 0 && [self.files count] - 1 >= self.currentPage) {
        self.currentFile=[self.files objectAtIndex:self.currentPage];
//        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
        [self resetCombinedBarTitleWithIndex:self.currentPage];
    }
}


#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    if (error) {
        return;
    }
    
    if (FC.filePath==nil) {
        return;
    }
    
    int anIndex = [self indexForFile:FC.fileName];
    PresenterCombinedSlideViewBaseItemController* baseItemController = [self.viewItemControllerList objectAtIndex:anIndex];
    [baseItemController loadContentWithPath:[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],FC.fileName]];
}

//find out the index for the given file name
-(int)indexForFile:(NSString*)fileName{
    for (int i=0; i<[self.files count];i++ ) {
        NSMutableDictionary* dict=[self.files objectAtIndex:i];
        NSString* name=[dict objectForKey:@"Name"];
        if ([name isEqualToString:fileName]) {
            return i;
        }
    }
    return 0;
}


- (void)dealloc {
    for (int i = 0; i < [self.viewItemControllerList count]; i++) {
        UIViewController* myViewController = [self.viewItemControllerList objectAtIndex:i];
        [myViewController willMoveToParentViewController:nil];
        [myViewController.view removeFromSuperview];
        [myViewController removeFromParentViewController];
    }
    self.scrollView = nil;
    self.viewItemControllerList = nil;
    [self.leafSmallTemplateViewController willMoveToParentViewController:nil];
    [self.leafSmallTemplateViewController.view removeFromSuperview];
    [self.leafSmallTemplateViewController removeFromParentViewController];
    self.leafSmallTemplateViewController = nil;
    self.arcosRootViewController = nil;
    self.emailAllBarButton = nil;
    
    [super dealloc];
}

- (void)resetCombinedBarTitleWithIndex:(int)index {
    NSString* previousTitle = @"";
    NSString* currentTitle = @"";
    NSString* nextTitle = @"";
    
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:index - 1];
        previousTitle = [NSString stringWithFormat:@"%@<",[cellDict objectForKey:@"Title"]];
    }
    @catch (NSException *exception) {
        
    }
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:index];
        currentTitle = [NSString stringWithFormat:@"%@",[cellDict objectForKey:@"Title"]];
    }
    @catch (NSException *exception) {
        
    }
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:index + 1];
        nextTitle = [NSString stringWithFormat:@">%@",[cellDict objectForKey:@"Title"]];
    }
    @catch (NSException *exception) {
        
    }
    self.title = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@ %@",previousTitle, currentTitle, nextTitle]];
}

#pragma mark PresenterCombinedSlideViewItemDelegate
- (void)didSelectPresenterCombinedSlideViewItem {
    [self toggleLeafSmallTemplateViewController];
}

#pragma mark LeafSmallTemplateViewItemDelegate
-(void)didSelectSmallTemplateViewItemWithButton:(UIButton*)aBtn indexPathRow:(int)anIndexPathRow {
    int tmpIndex = [ArcosUtils convertNSIntegerToInt:aBtn.tag];
    
    int myIndex = tmpIndex + self.leafSmallTemplateViewController.leafSmallTemplateDataManager.itemPerPage * anIndexPathRow;
    if (myIndex == self.currentPage) return;
    [self pauseVideoItemController];
    self.currentPage = myIndex;
    self.scrollView.contentOffset = CGPointMake(self.currentPage * self.scrollView.bounds.size.width, 0);
    if ([self.files count] > 0 && [self.files count] - 1 >= self.currentPage) {
        self.currentFile=[self.files objectAtIndex:self.currentPage];
        //        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
        [self resetCombinedBarTitleWithIndex:self.currentPage];
    }
}

- (void)toggleLeafSmallTemplateViewController {
    if (!self.isSlideUpViewShowing) {
        [self addLeafSmallTemplateView];
    }
    [self toggleLeafSmallTemplateViewProcessor];
}

- (void)addLeafSmallTemplateView {
    CGRect myScrollViewBounds = self.scrollView.bounds;
    CGRect slideUpViewFrame = CGRectMake(0, CGRectGetMaxY(myScrollViewBounds), myScrollViewBounds.size.width, self.slideUpViewHeight);
    self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
    [self.view addSubview:self.leafSmallTemplateViewController.view];
}

- (void)removeLeafSmallTemplateView {
    [self.leafSmallTemplateViewController.view removeFromSuperview];
}

- (void)toggleLeafSmallTemplateViewProcessor {
    CGRect myScrollViewBounds = self.scrollView.bounds;
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
            [self removeLeafSmallTemplateView];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.leafSmallTemplateViewController showSpecificPage:self.currentPage];
            [self.leafSmallTemplateViewController.view setFrame:slideUpViewFrame];
        } completion:^(BOOL finished){
            
        }];
    }
    self.isSlideUpViewShowing = !self.isSlideUpViewShowing;
}

- (void)refreshVideoItemController {
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:self.currentPage];
        if ([[cellDict objectForKey:@"employeeIUR"] intValue] == 6) {
            NSString* fileName = [cellDict objectForKey:@"Name"];
            NSString* filepath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
            PresenterCombinedSlideViewVideoItemController* PCSVVIC = [self.viewItemControllerList objectAtIndex:self.currentPage];
            [PCSVVIC loadContentWithPath:filepath];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)pauseVideoItemController {
    @try {
        NSDictionary* cellDict = [self.files objectAtIndex:self.currentPage];
        if ([[cellDict objectForKey:@"employeeIUR"] intValue] == 6) {
            PresenterCombinedSlideViewVideoItemController* PCSVVIC = [self.viewItemControllerList objectAtIndex:self.currentPage];
            [PCSVVIC pauseVideoItemController];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    [self.emailButtonAddressSelectDelegate emailDidSelectEmailRecipientRow:cellData];
}

#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if ([self.emailButtonAddressSelectDelegate isKindOfClass:[EmailAllButtonAddressSelectDataManager class]]) {
//        [self emailAllAlertView:alertView clickedButtonAtIndex:buttonIndex];
//    } else if ([self.emailButtonAddressSelectDelegate isKindOfClass:[EmailOneButtonAddressSelectDataManager class]]) {
//        [self emailOneAlertView:alertView clickedButtonAtIndex:buttonIndex];
//    }
//}

- (void)emailAllDidSelectEmailRecipientRow:(NSDictionary*)cellData {
    [super didSelectEmailRecipientRow:cellData];
}

//- (void)emailAllAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
//}

- (void)emailOneDidSelectEmailRecipientRow:(NSDictionary*)cellData {
//    [self.emailPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.auxEmailCellData = cellData;
    self.rowPointer = 0;
    self.removedFileList = [NSMutableArray array];
    NSMutableArray* emailDataList = [NSMutableArray arrayWithCapacity:1];
    if ([self.files count] > 0) {
        emailDataList = [NSMutableArray arrayWithObject:[self.files objectAtIndex:self.currentPage]];
    }
    [self getOverSizeFileListFromDataList:emailDataList];
    
    if ([self.candidateRemovedFileList count] > 0) {
        [self checkFileSizeWithIndex:self.rowPointer];
    } else {
        [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:emailDataList];
    }
}
/*
- (void)emailOneAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 36) return;
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.removedFileList addObject:[self.candidateRemovedFileList objectAtIndex:self.rowPointer]];
    }
    self.rowPointer++;
    if (self.rowPointer != [self.candidateRemovedFileList count]) {
        [self checkFileSizeWithIndex:self.rowPointer];
    } else {
        NSMutableArray* emailDataList = [NSMutableArray arrayWithCapacity:1];
        if ([self.files count] > 0) {
            emailDataList = [NSMutableArray arrayWithObject:[self.files objectAtIndex:self.currentPage]];
        }
        [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:emailDataList];
    }
}
*/
@end
