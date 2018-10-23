//
//  SavedOrderDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 13/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"
#import "SavedOrderTableCell.h"
#import "OrderProductViewController.h"

#import "OrderHeaderTotalViewController.h"
#import "OrderDetailModelViewController.h"

#import "OrderSenderCenter.h"
#import "ConnectivityCheck.h"
#import "OrderHeaderTotalGraphViewController.h"
#import "UtilitiesAnimatedViewController.h"
#import "ArcosXMLParser.h"
#import "OrderDetailTableViewController.h"
#import "UIViewController+ArcosStackedController.h"
#import "UtilitiesDetailViewController.h"
#import "ArcosConfigDataManager.h"
#import "SavedOrderPresenterTranDataManager.h"
#import "SavedOrderDetailDataManager.h"
@protocol SavedOrderDetailViewDelegate
-(void)needRefresh;

@end

@interface SavedOrderDetailViewController : UtilitiesDetailViewController<SelectionPopoverDelegate,ModelViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,OrderProductViewControllerDelegate,SavedOrderTableCellDelegate,UIAlertViewDelegate,OrderSenderCenterDelegate,ConnectivityDelegate,PresentViewControllerDelegate> {
    UILabel* _customerLabel;
    UILabel* _valueLabel;
    IBOutlet UIView* headerView;
    NSMutableArray* tableData;
    NSMutableArray* displayList;
    NSIndexPath* currentSelectDeleteIndexPath;
    NSMutableDictionary* currentSelectOrderHeader;
    UIPopoverController* selectionPopover;
    UIPopoverController* searchPopover;
    
    BOOL isCellEditable;
    
    UIAlertView* alert;
    
    NSInteger orderDisplayType;
    NSNumber* locationIUR;
    NSNumber* _lastOrderNumber;
    //delegate
    id<SavedOrderDetailViewDelegate>delegate;
    
    //orders
    NSMutableArray* orderQueue;
    OrderSenderCenter* senderCenter;
    
    //debug variable
    BOOL needVPNCheck;
    
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    UIViewController* _rootView;
    UINavigationController* _globalNavigationController;
//    ArcosConfigDataManager* _arcosConfigDataManager;
    SavedOrderPresenterTranDataManager* _savedOrderPresenterTranDataManager;
    SavedOrderDetailDataManager* _savedOrderDetailDataManager;
    MBProgressHUD* _HUD;
}
@property (nonatomic,retain) IBOutlet UILabel* customerLabel;
@property (nonatomic,retain) IBOutlet UILabel* valueLabel;
@property (nonatomic,retain) IBOutlet UIView* headerView;
@property (nonatomic,assign) BOOL isCellEditable;

@property (nonatomic,retain)  NSMutableArray* tableData;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSIndexPath* currentSelectDeleteIndexPath;
@property (nonatomic,retain)  NSMutableDictionary* currentSelectOrderHeader;
@property (nonatomic,assign)  id<SavedOrderDetailViewDelegate>delegate;
@property (nonatomic,retain)     NSMutableArray* orderQueue;
@property (nonatomic,retain) OrderSenderCenter* senderCenter;
@property (nonatomic,retain) UIAlertView* alert;
@property (nonatomic,assign) NSInteger orderDisplayType;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSNumber* lastOrderNumber;
@property (nonatomic,retain) UIViewController* rootView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
//@property (nonatomic,retain) ArcosConfigDataManager* arcosConfigDataManager;
@property (nonatomic,retain) SavedOrderPresenterTranDataManager* savedOrderPresenterTranDataManager;
@property (nonatomic,retain) SavedOrderDetailDataManager* savedOrderDetailDataManager;
@property (nonatomic,retain) MBProgressHUD* HUD;

- (IBAction) EditTable:(id)sender;

- (IBAction)DeleteButtonAction:(id)sender;
-(NSMutableDictionary*)selectionTotal;
@end
