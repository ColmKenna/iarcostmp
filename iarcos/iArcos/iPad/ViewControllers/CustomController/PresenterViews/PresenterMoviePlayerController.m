//
//  PresenterMoviePlayerController.m
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterMoviePlayerController.h"
#import "ArcosRootViewController.h"
 

@implementation PresenterMoviePlayerController
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize videoPlayerViewController = _videoPlayerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter.delegate=self;
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
// 
    [self.videoPlayerViewController willMoveToParentViewController:nil];
    [self.videoPlayerViewController.view removeFromSuperview];
    [self.videoPlayerViewController removeFromParentViewController];
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [moviePlayerController release];
//    moviePlayerController=nil;
    self.arcosRootViewController = nil;
    self.videoPlayerViewController = nil;
    
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
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    //make a movie player
//    moviePlayerController = [[MPMoviePlayerController alloc] init];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(moviePlaybackComplete:)
//												 name:MPMoviePlayerPlaybackDidFinishNotification
//											   object:moviePlayerController];
    
    //get the movie name
    NSString* fileName=@"";
    for (NSMutableDictionary* dict in self.files) {
        fileName=[dict objectForKey:@"Name"];
        
        //assaign current file
        self.currentFile=dict;
    }
    [self resetBarTitle:fileName];
    
    NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
	
    //if file is not exist then download it
    if ([FileCommon fileExistAtPath:filepath]) {
        [self loadMovieWithURL:fileURL];
    }else{
        [fileDownloadCenter addFileWithName:fileName];
        [fileDownloadCenter startDownload];
    }
}
-(void)loadMovieWithURL:(NSURL*)aUrl{
    if (aUrl==nil) {
        return;
    }
    /*
    moviePlayerController.contentURL=aUrl;
	[moviePlayerController.view setFrame:CGRectMake(0, 0, 1024, 748)];    
    
	[self.view addSubview:moviePlayerController.view];
    moviePlayerController.fullscreen = YES;
	
	//moviePlayerController.scalingMode = MPMovieScalingModeFill;
//    moviePlayerController.useApplicationAudioSession = YES;
    [moviePlayerController play];
    */
    self.videoPlayerViewController = [[[AVPlayerViewController alloc] init] autorelease];
    self.videoPlayerViewController.player = [AVPlayer playerWithURL:aUrl];
    [self.videoPlayerViewController.view setFrame:CGRectMake(0, 0, 1024, 748)];    
    [self addChildViewController:self.videoPlayerViewController];
    [self.view addSubview:self.videoPlayerViewController.view];
    [self.videoPlayerViewController didMoveToParentViewController:self];
    [self.videoPlayerViewController.player play];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    moviePlayerController.view.frame = self.arcosRootViewController.selectedRightViewController.view.bounds;
    self.videoPlayerViewController.view.frame = self.arcosRootViewController.selectedRightViewController.view.bounds;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    moviePlayerController.view.frame = self.view.bounds;
    self.videoPlayerViewController.view.frame = self.view.bounds;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (moviePlayerController.playbackState != MPMoviePlaybackStatePaused) {
//        [moviePlayerController pause];
//    }
    if ((int)self.videoPlayerViewController.player.rate == 1) {
        [self.videoPlayerViewController.player pause];
    }
//    NSLog(@"test %f",self.moviePlayer1.player.rate);
//    [self.moviePlayer1.player pause];
//    [moviePlayerController release];
//    moviePlayerController=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    moviePlayerController.view.frame = self.view.bounds;
    self.videoPlayerViewController.view.frame = self.view.bounds;
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
//    MPMoviePlayerController *moviePlayerController = [notification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//													name:MPMoviePlayerPlaybackDidFinishNotification
//												  object:moviePlayerController];
//	
//    [moviePlayerController.view removeFromSuperview];
//    [moviePlayerController release];
}

#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    if (error) {
        return;
    }
    
    NSURL    *fileURL    =   [NSURL fileURLWithPath:FC.filePath];
    [self loadMovieWithURL:fileURL];
}
-(void)allFilesDownload{
    
}
@end
