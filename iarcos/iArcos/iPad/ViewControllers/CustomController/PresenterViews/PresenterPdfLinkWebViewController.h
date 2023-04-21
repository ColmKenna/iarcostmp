//
//  PresenterPdfLinkWebViewController.h
//  iArcos
//
//  Created by Richard on 20/04/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "MBProgressHUD.h"

@interface PresenterPdfLinkWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView* _urlView;
    NSURL* _linkURL;
    MBProgressHUD* _HUD;
}

@property(nonatomic, retain) IBOutlet UIWebView* urlView;
@property(nonatomic, retain) NSURL* linkURL;
@property(nonatomic, retain) MBProgressHUD* HUD;

@end

