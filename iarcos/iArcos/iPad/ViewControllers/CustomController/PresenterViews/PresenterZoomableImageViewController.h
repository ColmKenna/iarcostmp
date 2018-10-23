//
//  PresenterZoomableImageViewController.h
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PresenterViewController.h"

@interface PresenterZoomableImageViewController : PresenterViewController<UIScrollViewDelegate> {
	UIImageView *image;
    IBOutlet UIScrollView* scroll;

}
@property(nonatomic,retain)    IBOutlet UIScrollView* scroll;

-(void)setImageForScorlling:(UIImageView*)aImageView;
@end
