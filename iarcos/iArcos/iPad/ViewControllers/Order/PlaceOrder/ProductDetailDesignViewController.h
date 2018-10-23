//
//  ProductDetailDesignViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "MBProgressHUD.h"

@interface ProductDetailDesignViewController : UIViewController <UIWebViewDelegate> {
    UIWebView* _myWebView;
    BOOL _isPageMultipleLoaded;
    NSString* _myURLString;
    MBProgressHUD* _HUD;
    BOOL _isDoingPopAction;
}

@property(nonatomic, retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, assign) BOOL isPageMultipleLoaded;
@property(nonatomic, retain) NSString* myURLString;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, assign) BOOL isDoingPopAction;

@end
