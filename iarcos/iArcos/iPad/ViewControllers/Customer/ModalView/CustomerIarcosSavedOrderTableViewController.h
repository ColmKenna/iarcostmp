//
//  CustomerIarcosSavedOrderTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerIarcosSavedOrderDataManager.h"
#import "CustomerIarcosSavedOrderTableCell.h"
#import "SavedIarcosOrderDetailTableViewController.h"
#import "UIViewController+ArcosStackedController.h"
#import "OrderSenderCenter.h"
#import "ConnectivityCheck.h"
#import "ArcosConfigDataManager.h"
#import "SavedOrderPresenterTranDataManager.h"
#import "ArcosDateRangeProcessor.h"

@interface CustomerIarcosSavedOrderTableViewController : UITableViewController <UIActionSheetDelegate, CustomerIarcosSavedOrderDelegate,OrderSenderCenterDelegate,ConnectivityDelegate,GetDataGenericDelegate,UIPopoverControllerDelegate,WidgetFactoryDelegate, OrderlinesIarcosTableViewControllerDelegate>{
    NSNumber* _locationIUR;
    NSNumber* _locationDefaultContactIUR;
    CustomerIarcosSavedOrderDataManager* _customerIarcosSavedOrderDataManager;
    OrderSenderCenter* _senderCenter;
    ConnectivityCheck* connectivityCheck;
//    ArcosConfigDataManager* _arcosConfigDataManager;
    SavedOrderPresenterTranDataManager* _savedOrderPresenterTranDataManager;
    UIBarButtonItem* _remoteButton;
    CallGenericServices* _callGenericServices;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSNumber* _coordinateType;
    MBProgressHUD* _HUD;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSNumber* locationDefaultContactIUR;
@property(nonatomic, retain) CustomerIarcosSavedOrderDataManager* customerIarcosSavedOrderDataManager;
@property(nonatomic, retain) OrderSenderCenter* senderCenter;
//@property (nonatomic,retain) ArcosConfigDataManager* arcosConfigDataManager;
@property (nonatomic,retain) SavedOrderPresenterTranDataManager* savedOrderPresenterTranDataManager;
@property (nonatomic,retain) UIBarButtonItem* remoteButton;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) WidgetFactory* factory;
//@property (nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property (nonatomic, retain) NSNumber* coordinateType;
@property (nonatomic,retain) MBProgressHUD* HUD;

- (void)deleteOrderHeader:(NSMutableDictionary*)data;

@end
