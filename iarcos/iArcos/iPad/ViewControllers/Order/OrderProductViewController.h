//
//  OrderProductViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProductTableCell.h"
#import "SelecteableTableViewController.h"
#import "OrderProductTotalModelViewController.h"
#import "OrderProductDetailModelViewController.h"
#import "OrderDetailViewController.h"
#import "WidgetFactory.h"
#import "ProductFormRowConverter.h"
#import "ProductDetailViewController.h"
#import "OrderLineDetailProductTableViewController.h"
#import "PresentViewControllerDelegate.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosStockonHandUtils.h"

@protocol OrderProductViewControllerDelegate 
-(void)deleteOrderHeaderWithOrderNnumber:(NSNumber*)orderNumber;
-(void)totalGoodsUpdateForOrderNumber:(NSNumber *)orderNumber withValue:(NSNumber *)totalGoods;
@end

@interface OrderProductViewController : OrderDetailViewController <SelectionPopoverDelegate,ModelViewDelegate,WidgetFactoryDelegate,UIActionSheetDelegate, PresentViewControllerDelegate, OrderLineDetailProductDelegate, UIPopoverControllerDelegate>{
    UILabel* _descTitleLabel;
    UILabel* _qtyTitleLabel;
    UILabel* _valueTitleLabel;
    UILabel* _discTitleLabel;
    UILabel* _bonTitleLabel;
    IBOutlet UIView* headerView;
    NSMutableArray* tableData;
    NSMutableArray* displayList;
    
    BOOL isCellEditable;
    NSMutableDictionary* currentSelectedOrderLine;
    NSMutableDictionary* backupSelectedOrderLine;

    //order input popover
    UIPopoverController* _inputPopover;
    WidgetFactory* factory;
    
    //delegate
    id<OrderProductViewControllerDelegate> delegate;
    
    //footer view 
    IBOutlet UIView* footerView;
    IBOutlet UILabel* totalValueLabel;
    IBOutlet UILabel* totalQtyLabel;
    IBOutlet UILabel* totalBonusLabel;
    IBOutlet UILabel* totalLinesLabel;
    UILabel* _totalTitleLabel;
    UILabel* _linesTitleLabel;
    NSNumber* _formIUR;
    NSNumber* _orderNumber;
    UINavigationController* _globalNavigationController;
    NSIndexPath* _currentSelectedIndexPath;
    UIViewController* _rootView;
    NSNumber* _locationIUR;
    ArcosStockonHandUtils* _arcosStockonHandUtils;
    NSMutableDictionary* _vansOrderHeader;
}

@property (nonatomic,retain) IBOutlet UILabel* descTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel* qtyTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel* valueTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel* discTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel* bonTitleLabel;
@property (nonatomic,retain)     IBOutlet UIView* headerView;
@property (nonatomic,assign)     BOOL isCellEditable;

@property (nonatomic,retain)  NSMutableArray* tableData;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSMutableDictionary* currentSelectedOrderLine;
@property (nonatomic,retain)  NSMutableDictionary* backupSelectedOrderLine;

@property(nonatomic,retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetFactory* factory;

@property(nonatomic,assign)  id<OrderProductViewControllerDelegate> delegate;

@property(nonatomic,retain) IBOutlet UIView* footerView;
@property(nonatomic,retain) IBOutlet UILabel* totalValueLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalQtyLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalBonusLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalLinesLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* linesTitleLabel;
@property(nonatomic,retain) NSNumber* formIUR;
@property(nonatomic,retain) NSNumber* orderNumber;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) NSIndexPath* currentSelectedIndexPath;
@property(nonatomic,retain) UIViewController* rootView;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) ArcosStockonHandUtils* arcosStockonHandUtils;
@property(nonatomic,retain) NSMutableDictionary* vansOrderHeader;

- (IBAction) EditTable:(id)sender;

- (IBAction)DeleteButtonAction:(id)sender;
-(NSMutableDictionary*)selectionTotal;

@end
