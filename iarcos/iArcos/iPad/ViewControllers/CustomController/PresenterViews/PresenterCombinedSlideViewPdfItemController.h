//
//  PresenterCombinedSlideViewPdfItemController.h
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterCombinedSlideViewBaseItemController.h"

@interface PresenterCombinedSlideViewPdfItemController : PresenterCombinedSlideViewBaseItemController<UIWebViewDelegate, UIGestureRecognizerDelegate> {
    UIWebView* _pdfView;
}

@property(nonatomic, retain) IBOutlet UIWebView* pdfView;


@end
