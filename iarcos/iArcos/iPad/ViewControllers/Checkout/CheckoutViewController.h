//
//  CheckoutViewController.h
//  Arcos
//
//  Created by David Kilmartin on 02/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FormRowsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WidgetFactory.h"
#import "OrderProductTableCell.h"
#import "CoreLocationController.h"
#import "ModelViewDelegate.h"
#import "MATCheckoutViewDelegate.h"
#import "CheckoutDataManager.h"
@class ArcosRootViewController;
#import <AVFoundation/AVFoundation.h>

@interface CheckoutViewController : UIViewController<WidgetFactoryDelegate,UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,CoreLocationControllerDelegate,UIAlertViewDelegate,OrderProductTableCellDelegate,AVAudioPlayerDelegate,UITextViewDelegate,UITextFieldDelegate> {
    id<ModelViewDelegate> _checkoutDelegate;
    id<MATCheckoutViewDelegate> _matDelegate;
    WidgetFactory* widgetFactory;
    IBOutlet UILabel* Name;
//    IBOutlet UILabel* Address;
    IBOutlet UILabel* OrderDate;
    IBOutlet UILabel* DeliveryDate;
    IBOutlet UILabel* Wholesaler;
    IBOutlet UILabel* Status;
    IBOutlet UILabel* Type;
    IBOutlet UILabel* CallType;
    IBOutlet UILabel* Contact;
    IBOutlet UITextField* CustomerRef;
    UILabel* _accountNumber;
    IBOutlet UITextView* Memo;
    IBOutlet UITableView* orders;
    IBOutlet UIButton* widgetPopPoint;
    UILabel* _currentLabel;
    
    UIPopoverController* _thePopover;
    
    NSMutableDictionary* orderHeader;
    
    //talbe view
    IBOutlet UITableView* checkoutList;
    IBOutlet UIView* headerView;
    IBOutlet UIView* footerView;
    NSMutableArray* sortedOrderKeys;
    NSMutableDictionary* orderLines;
    BOOL isCellEditable;
    
    IBOutlet UILabel* totalValueLabel;
    IBOutlet UILabel* totalQtyLabel;
    IBOutlet UILabel* totalBonusLabel;
    IBOutlet UILabel* totalLinesLabel;
    UILabel* _totalTitle;
    UILabel* _linesTitle;
    
    NSInteger currentControlTag;
    
    //location controller
    CoreLocationController *CLController;
    IBOutlet UILabel * Latitude;
    IBOutlet UILabel * Longitude;
    
    BOOL needRefreshData;
    BOOL isRequestSourceFromImageForm;

    UIView* _templateView;
    ArcosRootViewController* _rootView;
    
    UILabel* _orderDateTitle;
    UILabel* _deliveryDateTitle;
    UILabel* _wholesalerTitle;
    UILabel* _statusTitle;
    UILabel* _typeTitle;
    UILabel* _callTypeTitle;
    UILabel* _contactTitle;
    UILabel* _customerRefTitle;
    UILabel* _accountNumberTitle;
    UILabel* _memoTitle;
    
    UILabel* _descriptionTitle;
    UILabel* _priceTitle;
    UILabel* _qtyTitle;
    UILabel* _bonusTitle;
    UILabel* _discountTitle;
    UILabel* _valueTitle;
    CheckoutDataManager* _checkoutDataManager;
    AVAudioPlayer* _myAVAudioPlayer;
}
//testing change
//testing change 1
@property(nonatomic,retain) id<ModelViewDelegate> checkoutDelegate;
@property(nonatomic,retain) id<MATCheckoutViewDelegate> matDelegate;
@property(nonatomic,retain) WidgetFactory* widgetFactory;
@property(nonatomic,retain) IBOutlet UILabel* Name;
//@property(nonatomic,retain) IBOutlet UILabel* Address;
@property(nonatomic,retain) IBOutlet UILabel* OrderDate;
@property(nonatomic,retain) IBOutlet UILabel* DeliveryDate;
@property(nonatomic,retain) IBOutlet UILabel* Wholesaler;
@property(nonatomic,retain) IBOutlet UILabel* Status;
@property(nonatomic,retain) IBOutlet UILabel* Type;
@property(nonatomic,retain) IBOutlet UILabel* CallType;
@property(nonatomic,retain) IBOutlet UILabel* Contact;
@property(nonatomic,retain) IBOutlet UITextField* CustomerRef;
@property(nonatomic,retain) IBOutlet UILabel* accountNumber;
@property(nonatomic,retain) IBOutlet UITextView* Memo;
@property(nonatomic,retain) IBOutlet UITableView* orders;
@property(nonatomic,retain) IBOutlet UIButton* widgetPopPoint;
@property(nonatomic,retain) UILabel* currentLabel;
@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) NSMutableDictionary* orderHeader;

@property(nonatomic,retain) IBOutlet UITableView* checkoutList;
@property(nonatomic,retain) IBOutlet UIView* headerView;
@property(nonatomic,retain) IBOutlet UIView* footerView;
@property(nonatomic,retain) NSMutableArray* sortedOrderKeys;
@property(nonatomic,retain) NSMutableDictionary* orderLines;
@property (nonatomic,assign)     BOOL isCellEditable;

@property(nonatomic,retain) IBOutlet UILabel* totalValueLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalQtyLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalBonusLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalLinesLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalTitle;
@property(nonatomic,retain) IBOutlet UILabel* linesTitle;

@property (nonatomic, retain) CoreLocationController *CLController;
@property(nonatomic,retain) IBOutlet UILabel * Latitude;
@property(nonatomic,retain) IBOutlet UILabel * Longitude;
@property (nonatomic, assign) BOOL isRequestSourceFromImageForm;
@property(nonatomic,retain) IBOutlet UIView* templateView;
@property (nonatomic, retain) ArcosRootViewController* rootView;

@property(nonatomic,retain) IBOutlet UILabel* orderDateTitle;
@property(nonatomic,retain) IBOutlet UILabel* deliveryDateTitle;
@property(nonatomic,retain) IBOutlet UILabel* wholesalerTitle;
@property(nonatomic,retain) IBOutlet UILabel* statusTitle;
@property(nonatomic,retain) IBOutlet UILabel* typeTitle;
@property(nonatomic,retain) IBOutlet UILabel* callTypeTitle;
@property(nonatomic,retain) IBOutlet UILabel* contactTitle;
@property(nonatomic,retain) IBOutlet UILabel* customerRefTitle;
@property(nonatomic,retain) IBOutlet UILabel* accountNumberTitle;
@property(nonatomic,retain) IBOutlet UILabel* memoTitle;

@property(nonatomic,retain) IBOutlet UILabel* descriptionTitle;
@property(nonatomic,retain) IBOutlet UILabel* priceTitle;
@property(nonatomic,retain) IBOutlet UILabel* qtyTitle;
@property(nonatomic,retain) IBOutlet UILabel* bonusTitle;
@property(nonatomic,retain) IBOutlet UILabel* discountTitle;
@property(nonatomic,retain) IBOutlet UILabel* valueTitle;
@property(nonatomic,retain) CheckoutDataManager* checkoutDataManager;
@property(nonatomic,retain) AVAudioPlayer* myAVAudioPlayer;

-(void)backPressed:(id)sender;
-(void)removeAllRootSubViewsWithTag:(NSInteger)aTag;

@end
