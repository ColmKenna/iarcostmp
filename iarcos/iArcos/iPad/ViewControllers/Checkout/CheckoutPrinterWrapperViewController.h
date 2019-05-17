//
//  CheckoutPrinterWrapperViewController.h
//  iArcos
//
//  Created by David Kilmartin on 03/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingArea.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "CheckoutPDFRenderer.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CompositeErrorResult.h"
#import "OrderDetailOrderEmailActionDataManager.h"
#import "CheckoutPrinterOrderLineTableViewCell.h"
#import "CheckoutPrinterOrderLineHeaderView.h"
#import "CheckoutPrinterOrderLineFooterView.h"
#import "CheckoutPrinterWrapperDataManager.h"
#import "ArcosEmailValidator.h"
#import "ArcosMailWrapperViewController.h"
#import "ArcosMailWrapperViewController.h"
#import "ModalPresentViewControllerDelegate.h"

typedef enum {
    CheckoutPrinterDefault = 0,
    CheckoutPrinterCheckout
} CheckoutPrinterRequestSource;

@interface CheckoutPrinterWrapperViewController : UIViewController <MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ArcosMailTableViewControllerDelegate> {
    BOOL _isOrderPadPrinterType;
    CheckoutPrinterRequestSource _checkoutPrinterRequestSource;
//    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    UILabel* _locationNameLabel;
    UILabel* _address1Label;
    UILabel* _address2Label;
    UILabel* _address3Label;
    UILabel* _address4Label;
//    UILabel* _totalOrderValueTitleLabel;
//    UILabel* _totalOrderValueContentLabel;
    UITableView* _orderLineTableView;
    DrawingArea* _drawingAreaView;
    UILabel* _pleaseSignHereLabel;
    
    UIButton* _printButton;
    UIButton* _printEmailButton;
    UIButton* _bothButton;
    UIButton* _cancelButton;
    
//    NSMutableArray* _sortedOrderKeys;
//    CheckoutPDFRenderer* _checkoutPDFRenderer;
//    NSString* _fileName;
    CompositeErrorResult* _compositeErrorResult;
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _orderLines;
//    UIFont* _orderLineFont;
    UIImage* _logoImage;
    OrderDetailOrderEmailActionDataManager* _orderDetailOrderEmailActionDataManager;
    CheckoutPrinterOrderLineHeaderView* _orderLineHeaderView;
    CheckoutPrinterOrderLineFooterView* _orderLineFooterView;
    CheckoutPrinterWrapperDataManager* _checkoutPrinterWrapperDataManager;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    NSMutableArray* _descrDetailDictList;
    NSMutableDictionary* _descrDetailDictHashMap;
    NSMutableDictionary* _descrDetailIurLineValueHashMap;
    UILabel* _includePriceLabel;
    UISwitch* _includePriceSwitch;
}

@property(nonatomic, assign) BOOL isOrderPadPrinterType;
@property(nonatomic, assign) CheckoutPrinterRequestSource checkoutPrinterRequestSource;
//@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, retain) IBOutlet UILabel* locationNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* address1Label;
@property(nonatomic, retain) IBOutlet UILabel* address2Label;
@property(nonatomic, retain) IBOutlet UILabel* address3Label;
@property(nonatomic, retain) IBOutlet UILabel* address4Label;
//@property(nonatomic, retain) IBOutlet UILabel* totalOrderValueTitleLabel;
//@property(nonatomic, retain) IBOutlet UILabel* totalOrderValueContentLabel;
@property(nonatomic, retain) IBOutlet UITableView* orderLineTableView;
@property(nonatomic, retain) IBOutlet DrawingArea* drawingAreaView;
@property(nonatomic, retain) IBOutlet UILabel* pleaseSignHereLabel;
@property(nonatomic, retain) IBOutlet UIButton* printButton;
@property(nonatomic, retain) IBOutlet UIButton* printEmailButton;
@property(nonatomic, retain) IBOutlet UIButton* bothButton;
@property(nonatomic, retain) IBOutlet UIButton* cancelButton;
@property(nonatomic, retain) NSMutableArray* sortedOrderKeys;
//@property(nonatomic, retain) CheckoutPDFRenderer* checkoutPDFRenderer;
//@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, retain) CompositeErrorResult* compositeErrorResult;
@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableArray* orderLines;
//@property(nonatomic, retain) UIFont* orderLineFont;
@property(nonatomic, retain) UIImage* logoImage;
@property(nonatomic, retain) OrderDetailOrderEmailActionDataManager* orderDetailOrderEmailActionDataManager;
@property(nonatomic, retain) IBOutlet CheckoutPrinterOrderLineHeaderView* orderLineHeaderView;
@property(nonatomic, retain) IBOutlet CheckoutPrinterOrderLineFooterView* orderLineFooterView;
@property(nonatomic, retain) CheckoutPrinterWrapperDataManager* checkoutPrinterWrapperDataManager;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) NSMutableArray* descrDetailDictList;
@property (nonatomic, retain) NSMutableDictionary* descrDetailDictHashMap;
@property (nonatomic, retain) NSMutableDictionary* descrDetailIurLineValueHashMap;
@property(nonatomic, retain) IBOutlet UILabel* includePriceLabel;
@property(nonatomic, retain) IBOutlet UISwitch* includePriceSwitch;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)printButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)bothButtonPressed:(id)sender;
- (NSMutableArray*)createData;

@end
