//
//  PresenterCombinedSlideViewVideoItemController.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "PresenterCombinedSlideViewVideoItemController.h"

@interface PresenterCombinedSlideViewVideoItemController ()
- (void)layoutMySubviews;
@end

@implementation PresenterCombinedSlideViewVideoItemController
//@synthesize moviePlayerController = _moviePlayerController;
@synthesize videoPlayerViewController = _videoPlayerViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:self.moviePlayerController];
    */
//    [self.moviePlayerController.view removeFromSuperview];
//    self.moviePlayerController = nil;
    [self.videoPlayerViewController willMoveToParentViewController:nil];
    [self.videoPlayerViewController.view removeFromSuperview];
    [self.videoPlayerViewController removeFromParentViewController];
    self.videoPlayerViewController = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutMySubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pauseVideoItemController];
}

- (void)pauseVideoItemController {
//    if (self.moviePlayerController.playbackState != MPMoviePlaybackStatePaused) {
//        [self.moviePlayerController pause];
//    }
    if ((int)self.videoPlayerViewController.player.rate == 1) {
        [self.videoPlayerViewController.player pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self layoutMySubviews];
}

-(void)loadContentWithPath:(NSString*)aPath {
    NSURL* fileURL = [NSURL fileURLWithPath:aPath];
    /*
    if (self.moviePlayerController != nil) {
//        self.moviePlayerController = [[[MPMoviePlayerController alloc] initWithContentURL:fileURL] autorelease];
        
//        [self.moviePlayerController.view removeFromSuperview];
//        self.moviePlayerController = nil;
        return;
    }
    self.moviePlayerController = [[[MPMoviePlayerController alloc] initWithContentURL:fileURL] autorelease];
    [self.moviePlayerController prepareToPlay];

    self.moviePlayerController.view.frame = self.view.bounds;
    [self.view addSubview:self.moviePlayerController.view];
    self.moviePlayerController.shouldAutoplay = NO;
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [self.moviePlayerController.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    */
    
    if (self.videoPlayerViewController != nil) {
//        [self.videoPlayerViewController.view removeFromSuperview];
//        self.videoPlayerViewController = nil;
        return;
    } 
    self.videoPlayerViewController = [[[AVPlayerViewController alloc] init] autorelease];
    self.videoPlayerViewController.player = [AVPlayer playerWithURL:fileURL];
    
    self.videoPlayerViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.videoPlayerViewController];
    [self.view addSubview:self.videoPlayerViewController.view];
    [self.videoPlayerViewController didMoveToParentViewController:self];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.delegate = self;
    [self.videoPlayerViewController.view addGestureRecognizer:longPress];
    [longPress release];
    
}

#pragma mark Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleDoubleTapGesture:(id)sender {
    [self.itemDelegate didSelectPresenterCombinedSlideViewItem];
}
-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.itemDelegate didSelectPresenterCombinedSlideViewItem];
    }    
}

- (void)layoutMySubviews {
//    self.moviePlayerController.view.frame = self.view.bounds;
    self.videoPlayerViewController.view.frame = self.view.bounds;
}

- (void)movieExitFullscreen:(NSNotification *)notification
{
    NSLog(@"asa");
    [self layoutMySubviews];
}

@end
