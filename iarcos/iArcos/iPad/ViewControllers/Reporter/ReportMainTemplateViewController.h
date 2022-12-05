//
//  ReportMainTemplateViewController.h
//  iArcos
//
//  Created by Richard on 04/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "ReportTableViewController.h"
#import "ReporterXmlSubTableViewController.h"
#import "ReporterXmlGraphViewController.h"
#import "ReporterXmlExcelViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosMailWrapperViewController.h"
#import "ArcosEmailValidator.h"

@interface ReportMainTemplateViewController : UIViewController <ReporterXmlSubTableDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate, ArcosMailTableViewControllerDelegate> {
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
    ReportTableViewController* _reportTableViewController;
    UINavigationController* _reportNavigationController;
    ReporterXmlSubTableViewController* _reporterXmlSubTableViewController;
    ReporterXmlGraphViewController* _reporterXmlGraphViewController;
    NSArray* _layoutKeyList;
    NSArray* _layoutObjectList;
    NSArray* _objectViewControllerList;
    NSDictionary* _layoutDict;
    UIBarButtonItem* _emailButton;
    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    ReporterXmlExcelViewController* _reporterXmlExcelViewController;
    UIViewController* _rootView;
    UINavigationController* _globalNavigationController;
    MFMailComposeViewController* _mailController;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) ReportTableViewController* reportTableViewController;
@property(nonatomic, retain) UINavigationController* reportNavigationController;
@property(nonatomic, retain) ReporterXmlSubTableViewController* reporterXmlSubTableViewController;
@property(nonatomic, retain) ReporterXmlGraphViewController* reporterXmlGraphViewController;
@property(nonatomic, retain) NSArray* layoutKeyList;
@property(nonatomic, retain) NSArray* layoutObjectList;
@property(nonatomic, retain) NSArray* objectViewControllerList;
@property(nonatomic, retain) NSDictionary* layoutDict;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic, retain) ReporterXmlExcelViewController* reporterXmlExcelViewController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) MFMailComposeViewController* mailController;

@end


