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

@interface CustomerOrderDetailsModalViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* orderDetailListView;
    IBOutlet UIView* tableHeader;
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

    
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UITableView* orderDetailListView;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
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
@property (nonatomic,retain) IBOutlet UITextView* memo;
@property (nonatomic,retain) NSString* orderIUR;


-(IBAction)donePressed:(id)sender;


@end
