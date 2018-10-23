//
//  PresenterURLViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterViewController.h"
#import "MBProgressHUD.h"
@class ArcosRootViewController;

@interface PresenterURLViewController : PresenterViewController<UIWebViewDelegate> {
    UIWebView* _urlView;
//    UIActivityIndicatorView* _indicatorView;
    BOOL _isNotFirstLoaded;
    BOOL _isDoingPopAction;
    ArcosRootViewController* _arcosRootViewController;
    MBProgressHUD* _HUD;
}

@property(nonatomic, retain) IBOutlet UIWebView* urlView;
//@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* indicatorView;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) BOOL isDoingPopAction;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;

@end
