//
//  CustomerAccountOverviewViewController.h
//  Arcos
//
//  Created by David Kilmartin on 10/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "ArcosUtils.h"
#import "CallGenericServices.h"
#import "EmailRecipientTableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosEmailValidator.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "ActivateAppStatusManager.h"
#import "GenericWebViewItemViewController.h"
@class ArcosRootViewController;
#import "ArcosMailWrapperViewController.h"

@interface CustomerAccountOverviewViewController : UIViewController<EmailRecipientDelegate, MFMailComposeViewControllerDelegate,ArcosMailTableViewControllerDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    NSNumber* _locationIUR;
    NSString* _locationCode;
    IBOutlet UIWebView* myWebView;
    CallGenericServices* _callGenericServices;
//    NSString* _fileName;
    BOOL _isNotFirstLoaded;
//    NSString* _filePath;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UIPopoverController* _emailPopover;
    UIBarButtonItem* _emailButton;
    MFMailComposeViewController* _mailController;
    UIViewController* _myRootViewController;
    UIScrollView* _myScrollView;
    NSMutableArray* _displayList;
    NSMutableArray* _viewItemControllerList;
    ArcosRootViewController* _arcosRootViewController;
    int _currentPage;
    int _rowPointer;
    NSString* _overviewFolderName;
    UINavigationController* _globalNavigationController;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) NSString* locationCode;
@property(nonatomic,retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
//@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
//@property(nonatomic, retain) NSString* filePath;
@property(nonatomic,retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain) UIViewController* myRootViewController;
@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* viewItemControllerList;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSString* overviewFolderName;
@property(nonatomic, retain) UINavigationController* globalNavigationController;

@end
