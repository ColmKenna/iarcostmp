//
//  ReportExcelViewController.h
//  Arcos
//
//  Created by David Kilmartin on 15/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReporterFileManager.h"
#import "EmailRecipientTableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <QuickLook/QuickLook.h>
#import "ArcosEmailValidator.h"
#import "ArcosQLPreviewItem.h"
#import "ArcosMailWrapperViewController.h"

@interface ReportExcelViewController : UIViewController<UIWebViewDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, ArcosMailTableViewControllerDelegate>{
    IBOutlet UIWebView* myWebView;
    NSString* filePath;
    ReporterFileManager* _reporterFileManager;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _previewButton;
//    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    MFMailComposeViewController* _mailController;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}
@property (nonatomic,retain)     IBOutlet UIWebView* myWebView;
@property (nonatomic,retain)  NSString* filePath;
@property (nonatomic,retain) ReporterFileManager* reporterFileManager;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic,retain) UIBarButtonItem* previewButton;
//@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;

@end
