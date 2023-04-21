//
//  PresenterPDFViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PresenterViewController.h"
@class ArcosRootViewController;
#import "PresenterPdfLinkWebViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PresenterPDFViewController : PresenterViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
    IBOutlet UIWebView* pdfView;
    UIActivityIndicatorView* _indicatorView;
    ArcosRootViewController* _arcosRootViewController;
    MFMailComposeViewController* _mailController;
}
@property(nonatomic,retain)    IBOutlet UIWebView* pdfView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* indicatorView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) MFMailComposeViewController* mailController;

-(void)loadContentWithURL:(NSURL*)aUrl;
-(void)setResourceName:(NSString*)aName type:(NSString*)type;
-(void)reloadView;
-(void)loadContentWithFilePathURL:(NSURL*)aFilePathURL;
@end
