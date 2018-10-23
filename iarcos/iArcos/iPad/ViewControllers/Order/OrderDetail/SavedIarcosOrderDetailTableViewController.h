//
//  SavedIarcosOrderDetailTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedIarcosOrderDetailDataManager.h"
#import "SavedIarcosOrderDetailTableCellFactory.h"
#import "SavedIarcosOrderDetailControlTableViewCell.h"
#import "UIViewController+ArcosStackedController.h"
#import "OrderlinesIarcosTableViewController.h"
#import "DetailingTableViewController.h"
#import "ArcosEmailValidator.h"
#import "OrderDetailCallEmailActionDataManager.h"
#import "OrderDetailOrderEmailActionDataManager.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CheckoutPrinterWrapperViewController.h"
#import "RepeatOrderDataManager.h"

@interface SavedIarcosOrderDetailTableViewController : UITableViewController<OrderDetailTypesTableCellDelegate,EmailRecipientDelegate,MFMailComposeViewControllerDelegate,GetDataGenericDelegate, CustomisePresentViewControllerDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate, ModalPresentViewControllerDelegate, ArcosMailTableViewControllerDelegate> {
    UIBarButtonItem* _actionBarButton;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _saveButton;
    NSMutableArray* _rightBarButtonItemList;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UINavigationController* _emailNavigationController;
    UIPopoverController* _emailPopover;
    id<OrderDetailEmailActionDelegate> _emailActionDelegate;
    SavedIarcosOrderDetailDataManager* _savedIarcosOrderDetailDataManager;
    NSMutableDictionary* _savedOrderDetailCellData;
    NSMutableDictionary* _defaultOrderSentStatusDict;
    SavedIarcosOrderDetailTableCellFactory* _tableCellFactory;
    
    UILabel* _headerTitleLabel;
    UIButton* _headerButton;
    UILabel* _headerContentLabel;
    UIView* _myHeaderView;
    
    SavedIarcosOrderDetailControlTableViewCell* _contactDetailsTableViewCell;
    SavedIarcosOrderDetailControlTableViewCell* _orderDetailsTableViewCell;
    SavedIarcosOrderDetailControlTableViewCell* _memoDetailsTableViewCell;
    NSNumber* _coordinateType;
    CallGenericServices* _callGenericServices;
    WidgetFactory* _factory;
    UIPopoverController* _actionPopover;
    RepeatOrderDataManager* _repeatOrderDataManager;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}
@property(nonatomic, retain) UIBarButtonItem* actionBarButton;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIBarButtonItem* saveButton;
@property(nonatomic, retain) NSMutableArray* rightBarButtonItemList;
@property(nonatomic, retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic,retain) id<OrderDetailEmailActionDelegate> emailActionDelegate;
@property(nonatomic, retain) SavedIarcosOrderDetailDataManager* savedIarcosOrderDetailDataManager;
@property(nonatomic, retain) NSMutableDictionary* savedOrderDetailCellData;
@property(nonatomic, retain) NSMutableDictionary* defaultOrderSentStatusDict;
@property(nonatomic, retain) SavedIarcosOrderDetailTableCellFactory* tableCellFactory;

@property(nonatomic, retain) IBOutlet UILabel* headerTitleLabel;
@property(nonatomic, retain) IBOutlet UIButton* headerButton;
@property(nonatomic, retain) IBOutlet UILabel* headerContentLabel;
@property(nonatomic, retain) IBOutlet UIView* myHeaderView;
@property(nonatomic, retain) IBOutlet SavedIarcosOrderDetailControlTableViewCell* contactDetailsTableViewCell;
@property(nonatomic, retain) IBOutlet SavedIarcosOrderDetailControlTableViewCell* orderDetailsTableViewCell;
@property(nonatomic, retain) IBOutlet SavedIarcosOrderDetailControlTableViewCell* memoDetailsTableViewCell;
@property (nonatomic, retain) NSNumber* coordinateType;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* actionPopover;
@property(nonatomic,retain) RepeatOrderDataManager* repeatOrderDataManager;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* rootView;

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData;

@end
