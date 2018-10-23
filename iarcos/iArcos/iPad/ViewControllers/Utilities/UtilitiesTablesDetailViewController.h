//
//  UtilitiesTablesDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ArcosAppDelegate_iPad.h"
#import "UtilitiesDetailViewController.h"
#import "ArcosCoreData.h"
#import "UtilitiesTablesDetailTableCell.h"
#import "GenericUITableViewController.h"
#import "ModelViewDelegate.h"
#import "ArcosCustomiseAnimation.h"
#import "GenericWrapperUITableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosMailWrapperViewController.h"

@interface UtilitiesTablesDetailViewController : UtilitiesDetailViewController < MFMailComposeViewControllerDelegate, ClearTableDelegate,SlideAcrossViewAnimationDelegate, ArcosCustomiseAnimationDelegate,ArcosMailTableViewControllerDelegate> {
    NSMutableArray* _displayList;
    UIView* tableHeader;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    MFMailComposeViewController* _mailController;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) IBOutlet UIView* tableHeader;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) MFMailComposeViewController* mailController;

- (void)createDisplayList;

@end
