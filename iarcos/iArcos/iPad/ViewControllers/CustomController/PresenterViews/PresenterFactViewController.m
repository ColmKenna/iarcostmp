//
//  PresenterFactViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterFactViewController.h"
//#import "MainTabbarViewController.h"

@implementation PresenterFactViewController
@synthesize  image1;
@synthesize  image2;
@synthesize infoButton;
@synthesize myScrollView;
@synthesize zoomableView;
@synthesize imageViewer;
@synthesize imageUrls;
@synthesize myRootViewController = _myRootViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter.delegate=self;
        self.imageUrls=[NSMutableArray arrayWithObjects:[NSNull null], [NSNull null],nil];
    }
    return self;
}

- (void)dealloc
{
    [self.imageViewer.view removeFromSuperview];
    self.imageUrls = nil;
    self.image1 = nil;
    self.image2 = nil;
    self.infoButton = nil;
    self.myScrollView = nil;
    self.zoomableView = nil;
    self.imageViewer = nil;
    self.myRootViewController = nil;
    
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
    
    //[self.view insertSubview:image1 belowSubview:infoButton];
    //self.zoomableView.view.frame=self.view.frame;
    //[self.view insertSubview:self.zoomableView.view belowSubview:self.infoButton];
    self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    
//    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
//    if (currentOrientation==UIInterfaceOrientationLandscapeLeft||currentOrientation==UIInterfaceOrientationLandscapeRight) {
//        self.view.frame=CGRectMake(0, 0, 1024, 748);
//
//    }else{
//        self.view.frame=CGRectMake(0, 0, 768, 1004);
//
//    }
    
    
    self.imageViewer=[[[PresenterPDFViewController alloc]initWithNibName:@"PresenterPDFViewController" bundle:nil] autorelease];
    [self.imageViewer setResourceName:@"ArcosFactFront" type:@"png"];
    self.imageViewer.view.frame=self.view.frame;
    [self.view insertSubview:self.imageViewer.view belowSubview:self.infoButton];
//    NSLog(@"self fram is %f %f %f %f  orientation is %d",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height,[UIApplication sharedApplication].statusBarOrientation);
    
    
    //assaign current file
    if ([self.files count]>0) {
        self.currentFile=[self.files objectAtIndex:0];
        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
    }
    
    //loop through the presenter files
    for (int i=0; i<[self.files count];i++ ) {
        NSMutableDictionary* dict=[self.files objectAtIndex:i];
        NSString* fileName=[dict objectForKey:@"Name"];
        NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
        
        //if file is not exist then download it
        if ([FileCommon fileExistAtPath:filepath]) {
            [self.imageUrls replaceObjectAtIndex:i withObject:fileURL];
            if (i==0) {//load first page
                [self loadContentWithURL:fileURL forIndex:i];
            }
        }else{
            [fileDownloadCenter addFileWithName:fileName];
            [fileDownloadCenter startDownload];
        }
    }
    [self processRotationFrameEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self processRotationFrameEvent];
//    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
//    if (currentOrientation==UIInterfaceOrientationLandscapeLeft||currentOrientation==UIInterfaceOrientationLandscapeRight) {
//        self.view.frame=CGRectMake(0, 0, 1024, 748);
//        
//    }else{
//        self.view.frame=CGRectMake(0, 0, 768, 1024);
//        
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self processRotationFrameEvent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    /*
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        self.view.frame=CGRectMake(0, 0, 1024, 748);
        self.infoButton.frame=CGRectMake(950, 600, 18, 18);
    }else{
        self.view.frame=CGRectMake(0, 0, 768, 1024);
        self.infoButton.frame=CGRectMake(700, 850, 18, 18);

    }
    */
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.imageViewer.view.frame=self.view.frame;
    self.imageViewer.pdfView.scalesPageToFit=YES;
    [self processRotationEvent];
//    NSLog(@"info button is on %f %f %f %f",self.infoButton.frame.origin.x,infoButton.frame.origin.y,infoButton.frame.size.width,infoButton.frame.size.height);
}

-(void)loadContentWithURL:(NSURL*)aUrl forIndex:(int)index{
    if (aUrl==nil) {
        return;
    }
    
    if (self.infoButton.tag==index) {
//        [self.imageViewer loadContentWithURL:aUrl];
        [self.imageViewer loadContentWithFilePathURL:aUrl];
    }
}
-(IBAction)infoPressed:(id)sender{
    UIButton* aButton=(UIButton*)sender;

    
//    NSLog(@"button tapped with tag %d",aButton.tag);
    if (aButton.tag==0) {
        aButton.tag=1;
//        [image1 removeFromSuperview];
//        image2.frame=self.view.frame;
        
        if ([self.imageUrls objectAtIndex:1]==[NSNull null]) {
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.view
                                 cache:YES];
        
        //self.zoomableView.view.frame=self.view.frame;
//        self.imageViewer.view.frame=self.view.frame;
        

//        [self.imageViewer loadContentWithURL:[self.imageUrls objectAtIndex:1]];
        [self.imageViewer loadContentWithFilePathURL:[self.imageUrls objectAtIndex:1]];

        [UIView commitAnimations];
        
        //assaign current file
        self.currentFile=[self.files objectAtIndex:aButton.tag];
        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];

        
    }else{
        aButton.tag=0;
//        [image2 removeFromSuperview];
//        image1.frame=self.view.frame;
        
        if ([self.imageUrls objectAtIndex:1]==[NSNull null]) {
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.view
                                 cache:YES];
        
//        self.imageViewer.view.frame=self.view.frame;
        

        
//        [self.imageViewer loadContentWithURL:[self.imageUrls objectAtIndex:0]];
        [self.imageViewer loadContentWithFilePathURL:[self.imageUrls objectAtIndex:0]];
        [UIView commitAnimations];
        
        //assaign current file
        self.currentFile=[self.files objectAtIndex:aButton.tag];
        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];

    }
    
    [self processRotationEvent];
}


#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    if (error) {
        return;
    }
    
    NSURL    *fileURL    =   [NSURL fileURLWithPath:FC.filePath];
    int anIndex=[self indexForFile:FC.fileName];
    [self.imageUrls replaceObjectAtIndex:anIndex withObject:fileURL];
    
    if (fileURL==nil) {
        return;
    }
    
    [self loadContentWithURL:fileURL forIndex:anIndex];
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

-(void)allFilesDownload{
    
}

-(void)processRotationEvent {
    [self processRotationFrameEvent];
//    self.imageViewer.pdfView.frame = self.imageViewer.view.frame;
    [self loadContentWithURL:[self.imageUrls objectAtIndex:self.infoButton.tag] forIndex:[ArcosUtils convertNSIntegerToInt:self.infoButton.tag]];
}
-(void)processRotationFrameEvent {
    /*
    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation==UIInterfaceOrientationLandscapeLeft||currentOrientation==UIInterfaceOrientationLandscapeRight) {
        self.imageViewer.view.frame=CGRectMake(0, 0, 1024, 655);
    }else{
        self.imageViewer.view.frame=CGRectMake(0, 0, 768, 911);
    }
    */
    [ArcosUtils processRotationEvent:self.imageViewer.view tabBarHeight:0.0 navigationController:self.navigationController];
    
}

@end
