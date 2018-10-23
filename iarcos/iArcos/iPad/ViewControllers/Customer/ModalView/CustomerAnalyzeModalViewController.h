//
//  CustomerAnalyzeModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "CallGenericServices.h"
#import "SettingManager.h"
#import "ConnectivityCheck.h"
#import "ModelViewDelegate.h"

@interface CustomerAnalyzeModalViewController : UIViewController <UIWebViewDelegate, GetDataGenericDelegate> {
    IBOutlet UIWebView* myWebView;
    id<ModelViewDelegate> modalDelegate;
    NSNumber* locationIUR;
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
//    NSTimer* myTimer;
}

@property (nonatomic, retain) IBOutlet UIWebView* myWebView;
@property (nonatomic, retain) id<ModelViewDelegate> modalDelegate;
@property (nonatomic,retain)  NSNumber* locationIUR;

-(void)closePressed:(id)sender;
-(void)printingSelf;

@end
