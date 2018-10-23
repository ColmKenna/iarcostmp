//
//  PresenterMoviePlayerController.h
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>  
#import "PresenterViewController.h"
@class ArcosRootViewController;
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PresenterMoviePlayerController : PresenterViewController {
//    MPMoviePlayerController *moviePlayerController;
    ArcosRootViewController* _arcosRootViewController;
    AVPlayerViewController * _videoPlayerViewController;
}
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) AVPlayerViewController* videoPlayerViewController;

-(void)loadMovieWithURL:(NSURL*)aUrl;
@end
