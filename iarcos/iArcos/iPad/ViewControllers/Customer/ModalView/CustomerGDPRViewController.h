//
//  CustomerGDPRViewController.h
//  iArcos
//
//  Created by David Kilmartin on 02/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosUtils.h"
#import "FileCommon.h"
#import "DrawingArea.h"
#import "CustomerGDPRDataManager.h"
#import "WidgetFactory.h"
#import "OrderSharedClass.h"
#import "CustomerGDPRTableCell.h"
#import "CallGenericServices.h"
#import "ArcosCoreData.h"
#import "CustomerContactWrapperModalViewController.h"
#import "GenericRefreshParentContentDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PresenterPdfLinkWebViewController.h"
#import "ArcosMailWrapperViewController.h"

@interface CustomerGDPRViewController : UIViewController <WidgetFactoryDelegate, UIPopoverControllerDelegate, CustomerGDPRTableCellDelegate, GenericRefreshParentContentDelegate, CustomisePresentViewControllerDelegate, CustomerInfoAccessTimesCalendarTableViewControllerDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate, ArcosMailTableViewControllerDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    UILabel* _locationNameLabel;
    UILabel* _locationAddress;
    UILabel* _dateTitleLabel;
    UILabel* _dateContentLabel;
    UILabel* _timeTitleLabel;
    UILabel* _timeContentLabel;
    UIWebView* _myWebView;
    UITableView* _myTableView;
    DrawingArea* _drawingAreaView;
    UILabel* _signatureHintLabel;
    UIButton* _tapToSelectContactNameBtn;
    NSURL* _fileURL;
    CustomerGDPRDataManager* _customerGDPRDataManager;
    UIBarButtonItem* _saveButton;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
    CallGenericServices* _callGenericServices;
    UILabel* _myEmailAddressLabel;
    UIButton* _amendContactButton;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    MFMailComposeViewController* _mailController;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, retain) IBOutlet UILabel* locationNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* locationAddress;
@property(nonatomic, retain) IBOutlet UILabel* dateTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateContentLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeContentLabel;
@property(nonatomic, retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet DrawingArea* drawingAreaView;
@property(nonatomic, retain) IBOutlet UILabel* signatureHintLabel;
@property(nonatomic, retain) IBOutlet UIButton* tapToSelectContactNameBtn;
@property(nonatomic, retain) NSURL* fileURL;
@property(nonatomic, retain) CustomerGDPRDataManager* customerGDPRDataManager;
@property(nonatomic, retain) UIBarButtonItem* saveButton;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) IBOutlet UILabel* myEmailAddressLabel;
@property(nonatomic, retain) IBOutlet UIButton* amendContactButton;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) MFMailComposeViewController* mailController;

- (IBAction)tapToSelectContactNameButtonPressed:(id)sender;
- (IBAction)amendContactButtonPressed:(id)sender;

@end
