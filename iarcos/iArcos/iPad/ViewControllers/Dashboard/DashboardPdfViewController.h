//
//  DashboardPdfViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "ArcosUtils.h"

@interface DashboardPdfViewController : UIViewController {
    UIWebView* _myWebView;
}

@property(nonatomic, retain) IBOutlet UIWebView* myWebView;

@end
