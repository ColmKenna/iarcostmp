//
//  ReporterCsvViewController.h
//  iArcos
//
//  Created by Richard on 10/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosUtils.h"
#import "ReporterCsvDataManager.h"
#import "GenericUITableTableCell.h"
#import "LeftRightInsetUILabel.h"
#import "ReporterCsvDetailTableViewController.h"
#import "ArcosCustomiseAnimation.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EmailRecipientTableViewController.h"
#import "ArcosMailWrapperViewController.h"
#import "ReporterFileManager.h"
#import "ReporterCsvTableViewCell.h"

@interface ReporterCsvViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ArcosCustomiseAnimationDelegate, SlideAcrossViewAnimationDelegate, EmailRecipientDelegate, ArcosMailTableViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UIScrollView* _customiseScrollView;
    UIViewController* _myRootViewController;
    ReporterCsvDataManager* _reporterCsvDataManager;
    UIView* _customiseTableHeaderView;
    UITableView* _customiseTableView;
    UINavigationController* _globalNavigationController;
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UIBarButtonItem* _emailButton;
    UINavigationController* _emailNavigationController;
    ReporterFileManager* _reporterFileManager;
    MFMailComposeViewController* _mailController;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) IBOutlet UIScrollView* customiseScrollView;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, retain) ReporterCsvDataManager* reporterCsvDataManager;
@property(nonatomic, retain) UIView* customiseTableHeaderView;
@property(nonatomic, retain) UITableView* customiseTableView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property (nonatomic, retain) ReporterFileManager* reporterFileManager;
@property(nonatomic,retain) MFMailComposeViewController* mailController;

@end


