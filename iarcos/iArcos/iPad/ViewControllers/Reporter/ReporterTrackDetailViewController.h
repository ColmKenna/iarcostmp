//
//  ReporterTrackDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ReporterTrackDetailDataManager.h"
#import "ReporterFileManager.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"

@interface ReporterTrackDetailViewController : UIViewController<ReporterFileDelegate, UIWebViewDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate> {
    UIWebView* _myWebView;
    CallGenericServices* _callGenericServices;
    NSNumber* _reportIUR;
    NSDate* _startDate;
    NSDate* _endDate;
    BOOL _isNotFirstLoaded;
    ReporterTrackDetailDataManager* _reporterTrackDetailDataManager;
    BOOL _buyFlag;
    NSNumber* _levelIUR;
    NSNumber* _employeeIUR;
    NSDictionary* _configDict;
    ReporterFileManager* _reporterFileManager;
    UIBarButtonItem* _emailButton;
    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    MFMailComposeViewController* _mailController;
    NSString* _tableName;
    NSNumber* _selectedIUR;
}

@property(nonatomic, retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* reportIUR;
@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) ReporterTrackDetailDataManager* reporterTrackDetailDataManager;
@property (nonatomic, assign) BOOL buyFlag;
@property(nonatomic, retain) NSNumber* levelIUR;
@property(nonatomic, retain) NSNumber* employeeIUR;
@property(nonatomic, retain) NSDictionary* configDict;
@property (nonatomic,retain) ReporterFileManager* reporterFileManager;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic, retain) NSString* tableName;
@property(nonatomic, retain) NSNumber* selectedIUR;

@end
