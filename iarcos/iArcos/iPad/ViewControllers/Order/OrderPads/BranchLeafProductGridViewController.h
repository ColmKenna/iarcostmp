//
//  BranchLeafProductGridViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberInputPadViewController.h"
#import "BranchLeafProductDataManager.h"
//#import "BranchLeafProductGridTableViewCell.h"
#import "ArcosCoreData.h"
#import "LeafSmallTemplateViewController.h"
#import "LeafSmallTemplatePageIndexViewController.h"
#import "BranchLeafProductGridListTableViewCell.h"
#import "WidgetFactory.h"
#import "ProductDetailImageViewController.h"
#import "BranchLeafProductNavigationTitleDelegate.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "ProductDetailViewController.h"
@class ArcosRootViewController;

@interface BranchLeafProductGridViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NumberInputPadViewDelegate, LeafSmallTemplatePageIndexDelegate, LeafSmallTemplateViewItemDelegate,WidgetFactoryDelegate, BranchLeafProductGridListTableViewCellDelegate, UIPopoverPresentationControllerDelegate> {
    UIScrollView* _baseScrollContentView;
    NumberInputPadViewController* _numberInputPadViewController;
    BOOL _isNumberInputPadViewShowing;
    UITableView* _myTableView;
    BranchLeafProductDataManager* _branchLeafProductDataManager;
    LeafSmallTemplateViewController* _leafSmallTemplateViewController;
    float _slideUpViewHeight;    
    BOOL _isSlideUpViewShowing;
    LeafSmallTemplatePageIndexViewController* _pageIndexViewController;
    BOOL _isPageIndexViewShowing;
//    UIPopoverController* _inputPopover;
    WidgetViewController* _globalWidgetViewController;
    WidgetFactory* _factory;
    ArcosRootViewController* _rootView;
    id<BranchLeafProductNavigationTitleDelegate> _navigationTitleDelegate;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    NSNumber* _discountAllowedNumber;
    BOOL _showSeparator;
    BOOL _isLeafSmallHidden;
}

@property(nonatomic, retain) IBOutlet UIScrollView* baseScrollContentView;
@property(nonatomic, retain) NumberInputPadViewController* numberInputPadViewController;
@property(nonatomic, assign) BOOL isNumberInputPadViewShowing;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) BranchLeafProductDataManager* branchLeafProductDataManager;
@property(nonatomic, retain) LeafSmallTemplateViewController* leafSmallTemplateViewController;
@property(nonatomic, assign) float slideUpViewHeight;
@property(nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) LeafSmallTemplatePageIndexViewController* pageIndexViewController;
@property(nonatomic, assign) BOOL isPageIndexViewShowing;
//@property(nonatomic, retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) ArcosRootViewController* rootView;
@property(nonatomic, assign) id<BranchLeafProductNavigationTitleDelegate> navigationTitleDelegate;
@property(nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, retain) NSNumber* discountAllowedNumber;
@property(nonatomic, assign) BOOL showSeparator;
@property(nonatomic, assign) BOOL isLeafSmallHidden;

- (void)showLeafSmallTableViewController:(BOOL)aFlag;
- (void)showPageIndexView;
- (void)syncTableViewData;
- (void)productListSelectSmallTemplateViewItemWithData:(NSMutableDictionary*)aCellDataDict;
- (void)productListDoubleTapLargeImage;

@end

//@protocol BranchLeafProductNavigationTitleDelegate <NSObject>
//
//- (void)resetTopBranchLeafProductNavigationTitle:(NSString*)aDetail;
//
//@end

