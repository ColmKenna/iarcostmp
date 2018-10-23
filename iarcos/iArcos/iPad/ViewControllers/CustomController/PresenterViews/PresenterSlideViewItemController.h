//
//  PresenterSlideViewItemController.h
//  Arcos
//
//  Created by David Kilmartin on 26/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresenterSlideViewItemController : UIViewController{
    IBOutlet UIWebView* myWebView;
    IBOutlet UIImageView* myImage;
}
@property(nonatomic,retain)    IBOutlet UIWebView* myWebView;
@property(nonatomic,retain)  IBOutlet UIImageView* myImage;

@end
