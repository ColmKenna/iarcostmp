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

@interface CustomerInvoiceDetailsModalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* invoiceDetailListView;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
    NSString* IUR;
    
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

}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UITableView* invoiceDetailListView;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain) NSString* IUR;

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

-(IBAction)donePressed:(id)sender;

@end
