//
//  OrderDetailTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailDataManager.h"
#import "OrderDetailTableCellFactory.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"
#import "OrderDetailCallEmailActionDataManager.h"
#import "OrderDetailOrderEmailActionDataManager.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "OrderDetailContactControlTableCell.h"
#import "OrderProductViewController.h"
#import "DetailingTableViewController.h"
#import "ArcosValidator.h"
#import "UIViewController+ArcosStackedController.h"
#import "CheckoutPrinterWrapperViewController.h"
#import "RepeatOrderDataManager.h"
#import "ArcosMailWrapperViewController.h"
#import "CallGenericServices.h"


@interface OrderDetailTableViewController : UITableViewController<OrderDetailTypesTableCellDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate, OrderProductViewControllerDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate,ModalPresentViewControllerDelegate,ArcosMailTableViewControllerDelegate,GetDataGenericDelegate> {
    UIBarButtonItem* _actionBarButton;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _saveButton;
    NSMutableArray* _rightBarButtonItemList;
    OrderDetailDataManager* _orderDetailDataManager;
    OrderDetailTableCellFactory* _tableCellFactory;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UINavigationController* _emailNavigationController;
    UIPopoverController* _emailPopover;
    id<OrderDetailEmailActionDelegate> _emailActionDelegate;
    MFMailComposeViewController* _mailController;
    BOOL _isContactDetailShowed;
    OrderDetailContactControlTableCell* _contactControlTableCell;
    id<OrderProductViewControllerDelegate> _orderProductViewControllerDelegate;
    BOOL _isNotFirstLoaded;
    NSMutableDictionary* _savedOrderDetailCellData;
    NSMutableDictionary* _defaultOrderSentStatusDict;
    WidgetFactory* _factory;
    UIPopoverController* _actionPopover;
    RepeatOrderDataManager* _repeatOrderDataManager;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    CallGenericServices* _callGenericServices;
}

@property(nonatomic, retain) UIBarButtonItem* actionBarButton;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIBarButtonItem* saveButton;
@property(nonatomic, retain) NSMutableArray* rightBarButtonItemList;
@property(nonatomic, retain) OrderDetailDataManager* orderDetailDataManager;
@property(nonatomic, retain) OrderDetailTableCellFactory* tableCellFactory;
@property(nonatomic, retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic,retain) id<OrderDetailEmailActionDelegate> emailActionDelegate;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,assign) BOOL isContactDetailShowed;
@property(nonatomic,retain) IBOutlet OrderDetailContactControlTableCell* contactControlTableCell;
@property(nonatomic,retain) id<OrderProductViewControllerDelegate> orderProductViewControllerDelegate;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic,retain) NSMutableDictionary* savedOrderDetailCellData;
@property(nonatomic,retain) NSMutableDictionary* defaultOrderSentStatusDict;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* actionPopover;
@property(nonatomic,retain) RepeatOrderDataManager* repeatOrderDataManager;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* rootView;
@property(nonatomic, retain) CallGenericServices* callGenericServices;

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData;

@end
