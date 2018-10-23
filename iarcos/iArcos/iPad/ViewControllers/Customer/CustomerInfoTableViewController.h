//
//  CustomerInfoTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoCell.h"
#import "CustomerInfoButtonCell.h"
#import "CustomerOptionCell.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "CustomerInvoiceModalViewController.h"
#import "CustomerMemoModalViewController.h"
#import "CustomerNotBuyModalViewController.h"
#import "CustomerTyvLyModalViewController.h"
#import "CustomerDetailsWrapperModalViewController.h"
#import "ArcosCustomiseAnimation.h"
#import "ArcosUtils.h"
#import "CustomerContactInfoTableViewController.h"
#import "LocationStampMapView.h"
#import "CustomerFlagModalViewController.h"
#import "UtilitiesAnimatedViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PresentViewControllerDelegate.h"
#import "CustomerPhotoSlideViewController.h"
#import "CustomerAccountOverviewViewController.h"
#import "QueryOrderTemplateSplitViewController.h"
@class ArcosRootViewController;
#import "CustomerInfoTableDataManager.h"
#import "UIViewController+ArcosStackedController.h"
#import "CustomerIarcosSavedOrderTableViewController.h"
#import "CustomerCoverHomePageImageViewController.h"
#import "CustomerDetailsEditDataManager.h"
#import "CustomerInfoLinkedToTableViewCell.h"
#import "CustomerInfoAccessTimesTableViewCell.h"
#import "CustomerAccessTimesUtils.h"
#import "CustomerSurveySummaryTableViewController.h"
#import "ArcosMailWrapperViewController.h"
#import "CustomerGDPRViewController.h"

@interface CustomerInfoTableViewController : UITableViewController<CustomerOptionCellDelegate,ModelViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,GenericRefreshParentContentDelegate,MFMailComposeViewControllerDelegate,PresentViewControllerDelegate,SlideAcrossViewAnimationDelegate, ArcosCustomiseAnimationDelegate,CustomisePresentViewControllerDelegate,WidgetFactoryDelegate,UIPopoverControllerDelegate,GetDataGenericDelegate, CustomerInfoLinkedToTableViewCellDelegate, CustomerInfoAccessTimesCalendarTableViewControllerDelegate, ArcosMailTableViewControllerDelegate>{
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    NSMutableDictionary* aCustDict;
    NSNumber* custIUR;

    NSMutableArray* aCustKeys;

    BOOL needShowDetail;

    IBOutlet CustomerInfoCell* detailButCell;
    
    //UIView animation
    UINavigationController* _globalNavigationController;
    ArcosRootViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    
    NSMutableDictionary* orderHeader;

    UIButton* _myTopHeaderButtonView;
    UILabel* _myTopHeaderLabelView;
    UIView* _myTopHeaderView;
    NSNumber* _locationDefaultContactIUR;
    NSString* _locationDefaultContactName;
    MFMailComposeViewController* _mailController;
    
    CustomerInfoTableDataManager* _customerInfoTableDataManager;
    CustomerCoverHomePageImageViewController* _customerCoverHomePageImageViewController;
    CustomerDetailsEditDataManager* _customerDetailsBuyingGroupDataManager;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
    NSString* _accountBalanceLabel;
    CallGenericServices* _callGenericServices;
    CustomerTypesDataManager* _customerTypesDataManager;
    NSString* _myArcosAdminEmail;
    CustomerAccessTimesUtils* _customerAccessTimesUtils;
}
@property(nonatomic,assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic,retain)NSMutableDictionary* aCustDict;
@property(nonatomic,retain)NSNumber* custIUR;
@property(nonatomic,retain)NSMutableArray* aCustKeys;

@property(nonatomic,retain) IBOutlet CustomerInfoCell* detailButCell;

@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) ArcosRootViewController* rootView;

@property (nonatomic, retain) NSMutableDictionary* orderHeader;

@property (nonatomic, retain) IBOutlet UIButton* myTopHeaderButtonView;
@property (nonatomic, retain) IBOutlet UILabel* myTopHeaderLabelView;
@property (nonatomic, retain) IBOutlet UIView* myTopHeaderView;
@property (nonatomic, retain) NSNumber* locationDefaultContactIUR;
@property (nonatomic, retain) NSString* locationDefaultContactName;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain)    WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;

@property (nonatomic, retain) CustomerInfoTableDataManager* customerInfoTableDataManager;
@property (nonatomic, retain) CustomerCoverHomePageImageViewController* customerCoverHomePageImageViewController;
@property (nonatomic, retain) CustomerDetailsEditDataManager* customerDetailsBuyingGroupDataManager;
@property (nonatomic, retain) NSString* accountBalanceLabel;
@property (nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) CustomerTypesDataManager* customerTypesDataManager;
@property (nonatomic, retain) NSString* myArcosAdminEmail;
@property (nonatomic, retain) CustomerAccessTimesUtils* customerAccessTimesUtils;

- (void)addCoverHomePageImageView;
- (void)processAccountBalanceRecord;

@end
