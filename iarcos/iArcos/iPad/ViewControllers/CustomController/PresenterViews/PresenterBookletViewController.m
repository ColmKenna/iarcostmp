//
//  PresenterBookletViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterBookletViewController.h"
//#import "MainTabbarViewController.h"
#import "ArcosRootViewController.h"

@interface PresenterBookletViewController (Private) 
-(void)nextPage;
-(void)previousPage;
@end
@implementation PresenterBookletViewController
@synthesize currentImageView;
@synthesize imagePaths;
@synthesize myRootViewController = _myRootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter.delegate=self;
        self.imagePaths=[NSMutableArray array];

    }
    return self;
}

- (void)dealloc
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [bookletImages release];
    self.imagePaths = nil;
    self.currentImageView = nil;
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
    for (NSMutableDictionary* dict in self.files) {
        [self.imagePaths addObject:[NSNull null]];
    }

    currentBookletIndex=0;

    
    //add gesture recognizser
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    
    //assign current file
    if ([self.files count]>0) {
        self.currentFile=[self.files objectAtIndex:0];
        [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
    }
    
    for (int i=0; i<[self.files count];i++ ) {
        NSMutableDictionary* dict=[self.files objectAtIndex:i];
        NSString* fileName=[dict objectForKey:@"Name"];
        NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        //NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
        
        //if file is not exist then download it
        if ([FileCommon fileExistAtPath:filepath]) {
            [self.imagePaths replaceObjectAtIndex:i withObject:filepath];
            if (i==0) {//load first page
                [self loadContentWithPath:filepath forIndex:i];
            }
        }else{
            [fileDownloadCenter addFileWithName:fileName];
            [fileDownloadCenter startDownload];
        }
    }
    
    //empty imageview for first page
    if (self.currentImageView==nil) {
        self.currentImageView=[[[UIImageView alloc]init]autorelease];
        [self.view addSubview:self.currentImageView];
    }
    /*
    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation==UIInterfaceOrientationLandscapeLeft||currentOrientation==UIInterfaceOrientationLandscapeRight) {
        self.currentImageView.frame=CGRectMake(0, 0, 1024, 748);
    }else{
        self.currentImageView.frame=CGRectMake(0, 0, 768, 1024);
    }
    */
//    [self processRotationEvent];
    self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self processRotationEvent];
//    NSLog(@"frame2: %@ %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}
-(void)handleSwipeToRight:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe right received.");
    [self previousPage];
}
-(void)handleSwipeToLeft:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe Left received.");
    [self nextPage];
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
//    self.currentImageView.frame=self.view.frame;
    [self processRotationEvent];
}
-(void)nextPage{
    if (currentBookletIndex<([self.imagePaths  count]-1)) {
        if (self.currentImageView!=nil) {
            [self.currentImageView removeFromSuperview];
        }
        currentBookletIndex++;
        if ([self.imagePaths objectAtIndex:currentBookletIndex]==[NSNull null]) {
            //currentBookletIndex--;
            return;
        }
        
        //assign current file
        if ([self.files count]>0) {
            self.currentFile=[self.files objectAtIndex:currentBookletIndex];
            [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
        }
        
        //NSString* imageName=[bookletImages objectAtIndex:currentBookletIndex];
        UIImage* aImage=[UIImage imageWithContentsOfFile:[self.imagePaths objectAtIndex:currentBookletIndex]];
        //UIImage* aImage=[UIImage imageNamed:imageName];
        UIImageView* newImageView=[[[UIImageView alloc]initWithImage:aImage]autorelease];
        //newImageView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;        
        self.currentImageView=newImageView;
//        self.currentImageView.frame=self.view.frame;
        [self processRotationEvent];
        //animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                               forView:self.view
                                 cache:YES];
        [self.view addSubview:newImageView];
        [UIView commitAnimations];

    }
    if (currentBookletIndex>=([self.imagePaths count]-1)) {
        currentBookletIndex=[ArcosUtils convertNSUIntegerToUnsignedInt:[self.imagePaths count]]-1;
    }
}
-(void)previousPage{
    if (currentBookletIndex>0) {
        if (self.currentImageView!=nil) {
            [self.currentImageView removeFromSuperview];
        }
        currentBookletIndex--;
        if ([self.imagePaths objectAtIndex:currentBookletIndex]==[NSNull null]) {
            //currentBookletIndex--;
            return;
        }
        
        //assign current file
        if ([self.files count]>0) {
            self.currentFile=[self.files objectAtIndex:currentBookletIndex];
            [self resetBarTitle:[self.currentFile objectForKey:@"Name"]];
        }
        
       // NSString* imageName=[bookletImages objectAtIndex:currentBookletIndex];
        UIImage* aImage=[UIImage imageWithContentsOfFile:[self.imagePaths objectAtIndex:currentBookletIndex]];
        UIImageView* newImageView=[[[UIImageView alloc]initWithImage:aImage]autorelease];
        newImageView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
        self.currentImageView=newImageView;
//        self.currentImageView.frame=self.view.frame;
        [self processRotationEvent];
        //animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                               forView:self.view
                                 cache:YES];
        [self.view addSubview:newImageView];
        [UIView commitAnimations];
        
    }
    if (currentBookletIndex<=0) {
        currentBookletIndex=0;
    }
}


-(void)loadContentWithPath:(NSString*)aPath forIndex:(int)index{
    
    if (currentBookletIndex==index) {
        UIImage* aImage=[UIImage imageWithContentsOfFile:aPath];
        UIImageView* newImageView=[[[UIImageView alloc]initWithImage:aImage]autorelease];
        newImageView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
        self.currentImageView=newImageView;
        self.currentImageView.frame=self.view.frame;
        [self.view addSubview:newImageView];
//        NSLog(@"frame: %@ %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
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

-(void)allFilesDownload{
    
}
-(void)processRotationEvent {
//    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
//    if (currentOrientation==UIInterfaceOrientationLandscapeLeft||currentOrientation==UIInterfaceOrientationLandscapeRight) {
//        self.currentImageView.frame=CGRectMake(0, 0, 1024, 655);
//    }else{
//        self.currentImageView.frame=CGRectMake(0, 0, 768, 911);
//    }
    [ArcosUtils processRotationEvent:self.currentImageView tabBarHeight:0.0];
}

@end
