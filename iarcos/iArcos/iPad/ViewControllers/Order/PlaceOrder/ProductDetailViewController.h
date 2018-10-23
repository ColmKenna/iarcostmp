//
//  ProductDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ProductDetailLevelTableViewController.h"
//#import "ProductDetailSpecTableViewController.h"
#import "ProductDetailStockTableViewController.h"
#import "ProductDetailPriceTableViewController.h"
#import "ProductDetailCodeTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductDetailDataManager.h"
#import "ProductDetailImageViewController.h"
#import "ArcosCoreData.h"
#import "PresentViewControllerDelegate.h"
#import "ProductDetailDesignViewController.h"
typedef enum {
    ProductDetailRequestSourceFormRow = 0,
    ProductDetailRequestSourceProductDetail 
} ProductDetailRequestSource;

@interface ProductDetailViewController : UIViewController {
    id<PresentViewControllerDelegate> _presentViewDelegate;
    CallGenericServices* _callGenericServices;
    NSNumber* _productIUR;
    NSNumber* _locationIUR;
    UIImageView* _productCodeImageView;
    UIButton* _productCodeButtonView;
    UITableView* _levelTableView;
//    UITableView* _specTableView;
    UITableView* _stockTableView;
    UITableView* _priceTableView;
    UITableView* _codeTableView;
    ProductDetailLevelTableViewController* _levelTableViewController;
//    ProductDetailSpecTableViewController* _specTableViewController;
    ProductDetailStockTableViewController* _stockTableViewController;
    ProductDetailPriceTableViewController* _priceTableViewController;
    ProductDetailCodeTableViewController* _codeTableViewController;
    
    ProductDetailDataManager* _productDetailDataManager;
    BOOL _isNotFirstLoaded;
    ProductDetailRequestSource _productDetailRequestSource;
    UIImage* _mediumImage;
    
    UIButton* _posFilesButton;
    UIButton* _radioFilesButton;
    UIButton* _advertFilesButton;
    ArcosGenericClass* _myArcosGenericClass;
}

@property(nonatomic, assign) id<PresentViewControllerDelegate> presentViewDelegate;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* productIUR;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) IBOutlet UIImageView* productCodeImageView;
@property(nonatomic, retain) IBOutlet UIButton* productCodeButtonView;
@property(nonatomic, retain) IBOutlet UITableView* levelTableView;
//@property(nonatomic, retain) IBOutlet UITableView* specTableView;
@property(nonatomic, retain) IBOutlet UITableView* stockTableView;
@property(nonatomic, retain) IBOutlet UITableView* priceTableView;
@property(nonatomic, retain) IBOutlet UITableView* codeTableView;
@property(nonatomic, retain) ProductDetailLevelTableViewController* levelTableViewController;
//@property(nonatomic, retain) ProductDetailSpecTableViewController* specTableViewController;
@property(nonatomic, retain) ProductDetailStockTableViewController* stockTableViewController;
@property(nonatomic, retain) ProductDetailPriceTableViewController* priceTableViewController;
@property(nonatomic, retain) ProductDetailCodeTableViewController* codeTableViewController;
@property(nonatomic, retain) ProductDetailDataManager* productDetailDataManager;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, assign) ProductDetailRequestSource productDetailRequestSource;
@property(nonatomic, retain) UIImage* mediumImage;

@property(nonatomic, retain) IBOutlet UIButton* posFilesButton;
@property(nonatomic, retain) IBOutlet UIButton* radioFilesButton;
@property(nonatomic, retain) IBOutlet UIButton* advertFilesButton;
@property(nonatomic, retain) ArcosGenericClass* myArcosGenericClass;

- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation;
- (void)productDetailLandscapeLayoutAction;
- (IBAction)pressProductButtonView;
- (IBAction)posFilesButtonPressed:(id)sender;
- (IBAction)radioFilesButtonPressed:(id)sender;
- (IBAction)advertFilesButtonPressed:(id)sender;

@end
