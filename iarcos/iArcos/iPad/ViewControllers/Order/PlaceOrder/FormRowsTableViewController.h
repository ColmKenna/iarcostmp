//
//  FormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"
#import "OrderProductTableCell.h"
#import "SelectionPopoverViewController.h"
#import "ModelViewDelegate.h"
#import "OrderProductDetailModelViewController.h"
#import "OrderProductTotalModelViewController.h"
#import "WidgetFactory.h"
#import "CheckoutViewController.h"
#import "ArcosCustomiseAnimation.h"
#import "CustomerOrderModalViewController.h"
#import "ProductSearchDataManager.h"
#import "FormRowCurrentListSearchDataManager.h"
#import "ProductDetailViewController.h"
#import "ProductFormRowConverter.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "ArcosSystemCodesUtils.h"
#import "ArcosConfigDataManager.h"
#import "FormRowsTableDataManager.h"
#import "NextCheckoutViewController.h"
#import "ProductPredictiveSearchDataManager.h"
#import "FormRowsTableViewControllerDelegate.h"
#import "FormRowsDividerHeaderTableViewCell.h"
#import "FormRowsSubDividerHeaderTableViewCell.h"
#import "FormRowTableCellRrpGenerator.h"
#import "FormRowTableCellNormalGenerator.h"
#import "OrderPadFooterViewDataManager.h"
#import "OrderInputPadPopoverGeneratorProcessor.h"
#import "OrderEntryInputPopoverGeneratorProcessor.h"
#import "FormRowTableCellMyGenerator.h"
#import "FormRowTableCellPrevRrpGenerator.h"
#import "ArcosMyResult.h"
#import "FormRowTableHeaderView.h"
#import "FormRowTableCellPrevNormalGenerator.h"

@interface FormRowsTableViewController : OrderDetailViewController <SelectionPopoverDelegate,ModelViewDelegate,WidgetFactoryDelegate,UISearchBarDelegate, OrderProductTableCellDelegate,UIPopoverPresentationControllerDelegate>{
    id<FormRowsTableViewControllerDelegate> _actionDelegate;
    NSNumber* dividerIUR;
    NSString* dividerName;
    
    NSMutableDictionary* myGroups;
    NSMutableDictionary* displayList;
    NSMutableArray* groupName;
    NSMutableArray* sortKeys;
    NSMutableDictionary* _groupSelections;
    
    NSMutableArray* tableData;
    
    UILabel* _descTitleLabel;
    UILabel* _qtyTitleLabel;
    UILabel* _priceTitleLabel;
    UILabel* _valueTitleLabel;
    UILabel* _discTitleLabel;
    UILabel* _bonusTitleLabel;
    IBOutlet UIView* headerView;
    
    //selection
//    UIPopoverController* selectionPopover;
//    UIPopoverController* searchPopover;
    
    BOOL isCellEditable;
    
    //order input popover
//    UIPopoverController* _inputPopover;
    WidgetViewController* _globalWidgetViewController;
    WidgetFactory* _factory;
    
    //new array use for new implementation
    NSMutableArray* unsortedFormrows;
    NSMutableArray* _originalUnsortedFormrows;
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;    
    BOOL isRequestSourceFromImageForm;
    BOOL _isShowingSearchBar;
    UISearchBar* mySearchBar;
    BOOL _isSearchProductTable;
    ProductSearchDataManager* _productSearchDataManager;
    BOOL _isRequestSourceFromPresenter;    
    id<FormRowSearchDelegate> _formRowSearchDelegate;
    BOOL _isShowingTableHeaderView;
    BOOL _isNotFirstLoaded;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isShowingInStockFlag;
    FormRowsTableDataManager* _formRowsTableDataManager;
    BOOL _isVanSalesEnabledFlag;
    BOOL _isPredicativeSearchProduct;
    BOOL _isStandardOrderPadFlag;
    id<FormRowTableCellGeneratorDelegate> _formRowTableCellGeneratorDelegate;
    OrderPadFooterViewDataManager* _orderPadFooterViewDataManager;
    id<OrderPopoverGeneratorProcessorDelegate> _orderPopoverGeneratorProcessorDelegate;
}
@property(nonatomic,assign) id<FormRowsTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) NSNumber* dividerIUR;
@property(nonatomic,retain) NSString* dividerName;
@property(nonatomic,retain) NSMutableDictionary* myGroups;
@property(nonatomic,retain) NSMutableDictionary* displayList;
@property(nonatomic,retain) NSMutableArray* groupName;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* groupSelections;
@property(nonatomic,retain) NSMutableArray* tableData;

@property(nonatomic,retain) IBOutlet UILabel* descTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* qtyTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* priceTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* valueTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* discTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* bonusTitleLabel;
@property(nonatomic,retain) IBOutlet UIView* headerView;
//@property(nonatomic,retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) NSMutableArray* unsortedFormrows;
@property(nonatomic,retain) NSMutableArray* originalUnsortedFormrows;
@property (nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, assign) BOOL isRequestSourceFromImageForm;
//selection
@property (nonatomic,assign)     BOOL isCellEditable;
@property (nonatomic,assign) BOOL isShowingSearchBar;
@property (nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property (nonatomic,assign) BOOL isSearchProductTable;
@property(nonatomic,retain) ProductSearchDataManager* productSearchDataManager;
@property (nonatomic, assign) BOOL isRequestSourceFromPresenter;
@property (nonatomic,retain) id<FormRowSearchDelegate> formRowSearchDelegate;
@property (nonatomic, assign) BOOL isShowingTableHeaderView;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property (nonatomic, assign) BOOL isShowingInStockFlag;
@property (nonatomic,retain) FormRowsTableDataManager* formRowsTableDataManager;
@property (nonatomic, assign) BOOL isVanSalesEnabledFlag;
@property (nonatomic, assign) BOOL isPredicativeSearchProduct;
@property (nonatomic, assign) BOOL isStandardOrderPadFlag;
@property (nonatomic, retain) id<FormRowTableCellGeneratorDelegate> formRowTableCellGeneratorDelegate;
@property (nonatomic, retain) OrderPadFooterViewDataManager* orderPadFooterViewDataManager;
@property (nonatomic, retain) id<OrderPopoverGeneratorProcessorDelegate> orderPopoverGeneratorProcessorDelegate;

-(void)sortGroups:(NSMutableDictionary*)aList;
- (IBAction) EditTable:(id)sender;
- (IBAction)DeleteButtonAction:(id)sender;
-(NSMutableDictionary*)selectionTotal;

//functions
- (void)resetDividerFormRowsWithDividerIUR:(NSNumber*)anIUR withDividerName:(NSString*)name locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
-(void)resetDataWithDividerIUR:(NSNumber*)anIUR withDividerName:(NSString*)name locationIUR:(NSNumber*)aLocationIUR;
-(void)resetDataWithDividerRecordIUR:(NSNumber*)aDividerRecordIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
-(void)processUnsortedFormRows;
-(void)resetDataWithFormRows:(NSMutableDictionary*)formRows;
-(void)clearData;
-(NSMutableDictionary*)convertToOrderProductDict:(NSDictionary*)aDict;
//-(void)resetFormRowTableViewDataSource:(NSMutableArray*)aDataList;
- (void)resetTableViewDataSourceWithSearchText:(NSString*)aSearchText;
-(void)syncUnsortedFormRowsWithOriginal;
//functions to be called by FormRowCurrentListSearchDataManager
-(void)currentListSearchBarSearchButtonClicked:(NSString *)searchText;
-(void)currentListSearchBarCancelButtonClicked;
-(void)currentListSearchTextDidChange:(NSString *)searchText;
-(void)currentListSearchBarTextDidBeginEditing;
-(void)currentListSearchBarTextDidEndEditing;

- (void)reloadTableViewData;
- (void)scrollBehindSearchSection;
- (void)fillTheUnsortListWithData;
- (void)processDefaultQtyPercentProcessor:(NSMutableDictionary*)anOrderPadFormRow orderFormDetails:(NSString*)anOrderFormDetails;
-(void)saveOrderToTheCart:(NSMutableDictionary*)data;

@end
