//
//  CustomerInvoiceDetailsModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInvoiceDetailTableCell.h"
#import "ArcosUtils.h"
#import "CallGenericServices.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface CustomerInvoiceDetailsModalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate,UITextFieldDelegate,SlideAcrossViewAnimationDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* invoiceDetailListView;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
    NSString* IUR;
    NSString* _orderHeaderIUR;
    NSString* _orderNumber;
    UINavigationController* _globalNavigationController;
    
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    
    IBOutlet UITextView* textView;
    IBOutlet UITextField* employee;
    IBOutlet UITextField* type;
    IBOutlet UITextField* status;
    IBOutlet UITextField* deliveryBy;
    IBOutlet UITextField* number;
    IBOutlet UITextField* date;
    IBOutlet UITextField* ref;
    IBOutlet UITextField* order;    
    
    IBOutlet UITextField* comment1;
    IBOutlet UITextField* comment2;
    IBOutlet UITextField* carriage;
    IBOutlet UITextField* goods;
    IBOutlet UITextField* vat;
    IBOutlet UITextField* total;
    BOOL _screenLoadedFlag;
    
    UILabel* _employeeLabel;
    UILabel* _typeLabel;
    UILabel* _statusLabel;
    UILabel* _deliveryByLabel;
    UILabel* _numberLabel;
    UILabel* _dateLabel;
    UILabel* _refLabel;
    UILabel* _orderLabel;
    UILabel* _commentLabel;
    UILabel* _carriageLabel;
    UILabel* _goodsLabel;
    UILabel* _vatLabel;
    UILabel* _totalLabel;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UITableView* invoiceDetailListView;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain) NSString* IUR;
@property (nonatomic,retain) NSString* orderHeaderIUR;
@property (nonatomic,retain) NSString* orderNumber;
@property (nonatomic,retain) UINavigationController* globalNavigationController;

@property (nonatomic,retain) IBOutlet UITextView* textView;
@property (nonatomic,retain) IBOutlet UITextField* employee;
@property (nonatomic,retain) IBOutlet UITextField* type;
@property (nonatomic,retain) IBOutlet UITextField* status;
@property (nonatomic,retain) IBOutlet UITextField* deliveryBy;
@property (nonatomic,retain) IBOutlet UITextField* number;
@property (nonatomic,retain) IBOutlet UITextField* date;
@property (nonatomic,retain) IBOutlet UITextField* ref;
@property (nonatomic,retain) IBOutlet UITextField* order;

@property (nonatomic,retain) IBOutlet UITextField* comment1;
@property (nonatomic,retain) IBOutlet UITextField* comment2;
@property (nonatomic,retain) IBOutlet UITextField* carriage;
@property (nonatomic,retain) IBOutlet UITextField* goods;
@property (nonatomic,retain) IBOutlet UITextField* vat;
@property (nonatomic,retain) IBOutlet UITextField* total;
@property (nonatomic,assign) BOOL screenLoadedFlag;

@property (nonatomic,retain) IBOutlet UILabel* employeeLabel;
@property (nonatomic,retain) IBOutlet UILabel* typeLabel;
@property (nonatomic,retain) IBOutlet UILabel* statusLabel;
@property (nonatomic,retain) IBOutlet UILabel* deliveryByLabel;
@property (nonatomic,retain) IBOutlet UILabel* numberLabel;
@property (nonatomic,retain) IBOutlet UILabel* dateLabel;
@property (nonatomic,retain) IBOutlet UILabel* refLabel;
@property (nonatomic,retain) IBOutlet UILabel* orderLabel;
@property (nonatomic,retain) IBOutlet UILabel* commentLabel;
@property (nonatomic,retain) IBOutlet UILabel* carriageLabel;
@property (nonatomic,retain) IBOutlet UILabel* goodsLabel;
@property (nonatomic,retain) IBOutlet UILabel* vatLabel;
@property (nonatomic,retain) IBOutlet UILabel* totalLabel;

-(IBAction)donePressed:(id)sender;

@end
