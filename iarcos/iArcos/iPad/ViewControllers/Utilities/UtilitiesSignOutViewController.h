//
//  UtilitiesSignOutViewController.h
//  iArcos
//
//  Created by Apple on 30/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ModalPresentViewControllerDelegate.h"

@interface UtilitiesSignOutViewController : UIViewController {
    id<ModalPresentViewControllerDelegate> _delegate;
    WKWebView* _myWebView;
    NSDictionary* _layoutDict;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> delegate;
@property(nonatomic, retain) WKWebView* myWebView;
@property(nonatomic, retain) NSDictionary* layoutDict;

@end

