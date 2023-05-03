//
//  CustomerOrderDetailsModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 25/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerOrderDetailTableCell.h"
#import "CallGenericServices.h"
#import "ArcosUtils.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "CustomerOrderDetailsHeaderView.h"
#import "OrderEntryInputDataManager.h"

@interface CustomerOrderDetailsModalViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate,UITextFieldDelegate,SlideAcrossViewAnimationDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* orderDetailListView;
    IBOutlet CustomerOrderDetailsHeaderView* tableHeader;
    NSMutableArray* displayList;    
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    NSString* orderIUR;
    
    IBOutlet UITextView* textView;
    IBOutlet UITextField* employee;
    IBOutlet UITextField* type;
    IBOutlet UITextField* form;
    IBOutlet UITextField* status;
    IBOutlet UITextField* number;
    IBOutlet UITextField* date;
    IBOutlet UITextField* ref;
    IBOutlet UITextField* contact;
    
    
    IBOutlet UITextField* delivery;
    IBOutlet UITextField* deliveryBy;
    IBOutlet UITextField* deliveryStatus;
    IBOutlet UITextField* instructions;
    IBOutlet UITextField* instructions2;
    IBOutlet UITextView* memo;
    IBOutlet UITextField* value;
    UITextField* _goods;
    UITextField* _vat;
    OrderEntryInputDataManager* _orderEntryInputDataManager;
    NSString* _invoiceRef;
    NSString* _invoiceHeaderIUR;
    BOOL _screenLoadedFlag;
    UINavigationController* _globalNavigationController;
    
    UILabel* _employeeLabel;
    UILabel* _typeLabel;
    UILabel* _formLabel;
    UILabel* _statusLabel;
    UILabel* _numberLabel;
    UILabel* _dateLabel;
    UILabel* _refLabel;
    UILabel* _deliveryLabel;
    UILabel* _deliveryByLabel;
    UILabel* _invoiceLabel;
    UILabel* _instructionsLabel;
    UILabel* _memoLabel;
    UILabel* _valueLabel;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UITableView* orderDetailListView;
@property (nonatomic, retain) IBOutlet CustomerOrderDetailsHeaderView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain) IBOutlet UITextView* textView;
@property (nonatomic,retain) IBOutlet UITextField* employee;
@property (nonatomic,retain) IBOutlet UITextField* type;
@property (nonatomic,retain) IBOutlet UITextField* form;
@property (nonatomic,retain) IBOutlet UITextField* status;
@property (nonatomic,retain) IBOutlet UITextField* number;
@property (nonatomic,retain) IBOutlet UITextField* date;
@property (nonatomic,retain) IBOutlet UITextField* ref;
@property (nonatomic,retain) IBOutlet UITextField* contact;

@property (nonatomic,retain) IBOutlet UITextField* delivery;
@property (nonatomic,retain) IBOutlet UITextField* deliveryBy;
@property (nonatomic,retain) IBOutlet UITextField* deliveryStatus;
@property (nonatomic,retain) IBOutlet UITextField* instructions;
@property (nonatomic,retain) IBOutlet UITextField* instructions2;
@property (nonatomic,retain) IBOutlet UITextField* value;
@property (nonatomic,retain) IBOutlet UITextField* goods;
@property (nonatomic,retain) IBOutlet UITextField* vat;
@property (nonatomic,retain) IBOutlet UITextView* memo;
@property (nonatomic,retain) NSString* orderIUR;
@property(nonatomic, retain) OrderEntryInputDataManager* orderEntryInputDataManager;
@property(nonatomic, retain) NSString* invoiceRef;
@property(nonatomic, retain) NSString* invoiceHeaderIUR;
@property(nonatomic, assign) BOOL screenLoadedFlag;
@property (nonatomic,retain) UINavigationController* globalNavigationController;

@property (nonatomic,retain) IBOutlet UILabel* employeeLabel;
@property (nonatomic,retain) IBOutlet UILabel* typeLabel;
@property (nonatomic,retain) IBOutlet UILabel* formLabel;
@property (nonatomic,retain) IBOutlet UILabel* statusLabel;
@property (nonatomic,retain) IBOutlet UILabel* numberLabel;
@property (nonatomic,retain) IBOutlet UILabel* dateLabel;
@property (nonatomic,retain) IBOutlet UILabel* refLabel;
@property (nonatomic,retain) IBOutlet UILabel* deliveryLabel;
@property (nonatomic,retain) IBOutlet UILabel* deliveryByLabel;
@property (nonatomic,retain) IBOutlet UILabel* invoiceLabel;
@property (nonatomic,retain) IBOutlet UILabel* instructionsLabel;
@property (nonatomic,retain) IBOutlet UILabel* memoLabel;
@property (nonatomic,retain) IBOutlet UILabel* valueLabel;

-(IBAction)donePressed:(id)sender;


@end
