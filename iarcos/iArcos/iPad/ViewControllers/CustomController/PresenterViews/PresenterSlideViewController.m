//
//  PresenterSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 26/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PresenterSlideViewController.h"
#import "PresenterSlideViewItemController.h"
#import "ArcosRootViewController.h"

@interface PresenterSlideViewController ()
- (void)alignSubviewsWillAppear;
- (void)alignSubviews;
@end

@implementation PresenterSlideViewController

@synthesize scrollView = _scrollView;
@synthesize viewItems;
@synthesize imagePaths;
@synthesize arcosRootViewController = _arcosRootViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        fileDownloadCenter.delegate=self;
        self.imagePaths=[NSMutableArray array];
    }
    return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    pageControlUsed=NO;

	// Set up some colorful content views
    self.viewItems=[NSMutableArray array];
	views = [[NSMutableArray alloc] initWithCapacity:[self.files count]];
	
//    UIInterfaceOrientation or=[UIApplication sharedApplication].statusBarOrientation;
//    if (or== UIInterfaceOrientationPortrait||or==UIInterfaceOrientationPortraitUpsideDown) {
//        self.view.frame=CGRectMake(0, 0, 768, 911);
//    }else{
//        self.view.frame=CGRectMake(0, 0, 1024, 655);
//    }
    
    //NSLog(@"init scrolling view bound is %f  %f  %f  %f",scrollView.bounds.origin.x,scrollView.bounds.origin.y,scrollView.bounds.size.width,scrollView.bounds.size.height);
    
    
    //assign current file
    if ([self.files count]>0) {
        self.currentFile=[self.files objectAtIndex:0];
        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
    }
    
    for (int i=0; i<[self.files count];i++ ) {
        //add views
        PresenterSlideViewItemController* PSCIC=[[PresenterSlideViewItemController alloc]initWithNibName:@"PresenterSlideViewItemController" bundle:nil];
        [self.viewItems addObject:PSCIC];
        [PSCIC release];
		UIView *v = PSCIC.view;

        [self.scrollView addSubview:v];
		[views addObject:v];
        
        //add file paths
        NSMutableDictionary* dict=[self.files objectAtIndex:i];
        NSString* fileName=[dict objectForKey:@"Name"];
        NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        //NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
        
        //if file is not exist then download it
        if ([FileCommon fileExistAtPath:filepath]) {
            [self.imagePaths addObject:filepath];
            //if (i==0) {//load first page
                [self loadContentWithPath:filepath forIndex:i];
            //}
        }else{
            [self.imagePaths addObject:[NSNull null]];
            [fileDownloadCenter addFileWithName:fileName];
            [fileDownloadCenter startDownload];
        }
    }
    
    [self alignSubviewsWillAppear];
	
	[self.scrollView flashScrollIndicators];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self alignSubviewsWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self alignSubviews];
}

- (void)alignSubviewsWillAppear {
    int statusBarHeight = [self retrieveStatusBarHeight];
    float tmpPageWidth = self.arcosRootViewController.selectedRightViewController.view.frame.size.width;
    float tmpPageHeight = self.arcosRootViewController.selectedRightViewController.view.frame.size.height - statusBarHeight - self.navigationController.navigationBar.frame.size.height;

    self.scrollView.contentSize = CGSizeMake([self.files count] * tmpPageWidth, tmpPageHeight);
    NSUInteger i = 0;
    for (UIView *v in views) {
        v.frame = CGRectMake(i * tmpPageWidth, 0, tmpPageWidth, tmpPageHeight);
        i++;
    }
}

- (void)alignSubviews {
	// Position all the content views at their respective page positions
//    --scrollView.frame=self.view.frame;
//    NSLog(@"allign self frame is %f  %f  %f  %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//
//    NSLog(@"allign subview scrolling view bound is %f  %f  %f  %f",scrollView.bounds.origin.x,scrollView.bounds.origin.y,scrollView.bounds.size.width,scrollView.bounds.size.height);    
	self.scrollView.contentSize = CGSizeMake([self.files count]*self.scrollView.bounds.size.width,
										self.scrollView.bounds.size.height);
	NSUInteger i = 0;
	for (UIView *v in views) {
		v.frame = CGRectMake(i * self.scrollView.bounds.size.width, 0,
							 self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
		i++;
	}
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration {
    currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
//    UIInterfaceOrientation or=[UIApplication sharedApplication].statusBarOrientation;
//    if (or== UIInterfaceOrientationPortrait||or==UIInterfaceOrientationPortraitUpsideDown) {
//        self.view.frame=CGRectMake(0, 0, 768, 911);
//    }else{
//        self.view.frame=CGRectMake(0, 0, 1024, 655);
//    }
    [self alignSubviews];
	self.scrollView.contentOffset = CGPointMake(currentPage * self.scrollView.bounds.size.width, 0);
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
	[views release];
	views = nil;
}

-(void)loadContentWithPath:(NSString*)aPath forIndex:(int)index{

    //if (currentPage==index) {
        UIImage* aImage=[UIImage imageWithContentsOfFile:aPath];
        PresenterSlideViewItemController* PSCIC=(PresenterSlideViewItemController*)[self.viewItems objectAtIndex:index];
        PSCIC.myImage.image=aImage;  
//        NSURL    *fileURL    =   [NSURL fileURLWithPath:aPath];
//        [PSCIC.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    //}
    
    pageControlUsed=YES;

}

#pragma scrolling view delegate
-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
    if (!pageControlUsed) {
        currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
        //[self loadContentWithPath:[self.imagePaths objectAtIndex:currentPage] forIndex:currentPage]; 
        
//        NSLog(@"current page is %d",currentPage);
        self.currentFile=[self.files objectAtIndex:currentPage];
        pageControlUsed=YES;
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

#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    if (error) {
        return;
    }
    
    if (FC.filePath==nil) {
        return;
    }
    
    int anIndex=[self indexForFile:FC.fileName];
    [self.imagePaths replaceObjectAtIndex:anIndex withObject:FC.filePath];
    [self loadContentWithPath:FC.filePath forIndex:anIndex];
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
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView = nil;
	[views release];
    for (int i = 0; i < [self.viewItems count]; i++) {
        PresenterSlideViewItemController* PSCIC = (PresenterSlideViewItemController*)[self.viewItems objectAtIndex:i];
        PSCIC.myImage.image = nil;
    }
    self.viewItems = nil;
    self.imagePaths = nil;
    self.arcosRootViewController = nil;
    
    [super dealloc];
}

@end

