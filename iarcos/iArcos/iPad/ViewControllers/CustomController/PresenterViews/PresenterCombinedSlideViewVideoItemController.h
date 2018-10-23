//
//  PresenterCombinedSlideViewVideoItemController.h
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>
#import "PresenterCombinedSlideViewBaseItemController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PresenterCombinedSlideViewVideoItemController : PresenterCombinedSlideViewBaseItemController<UIGestureRecognizerDelegate> {
//    MPMoviePlayerController* _moviePlayerController;
    AVPlayerViewController* _videoPlayerViewController;
}

//@property(nonatomic, retain) MPMoviePlayerController* moviePlayerController;
@property(nonatomic, retain) AVPlayerViewController* videoPlayerViewController;

- (void)pauseVideoItemController;

@end
