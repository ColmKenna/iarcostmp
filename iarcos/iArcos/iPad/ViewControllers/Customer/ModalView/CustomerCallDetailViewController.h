//
//  CustomerCallDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCallDetailTableCell.h"
#import "ArcosUtils.h"
#import "CallGenericServices.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface CustomerCallDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate,UITextFieldDelegate,SlideAcrossViewAnimationDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UITableView* callDetailListView;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    
    NSString* IUR;
    
    IBOutlet UITextView* textView;
    IBOutlet UITextField* employee;
    IBOutlet UITextField* type;
    IBOutlet UITextField* contact;
    IBOutlet UITextField* date;    
    
    IBOutlet UITextView* memo;
    
    UILabel* _orderLabel;
    UITextField* _orderTextField;
    NSString* _orderHeaderIUR;
    NSString* _orderNumber;
    BOOL _screenLoadedFlag;
    UINavigationController* _globalNavigationController;
    
    UILabel* _employeeLabel;
    UILabel* _typeLabel;
    UILabel* _contactLabel;
    UILabel* _dateLabel;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UITableView* callDetailListView;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain) NSString* IUR;

@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UITextField* employee;
@property (nonatomic, retain) IBOutlet UITextField* type;
@property (nonatomic, retain) IBOutlet UITextField* contact;
@property (nonatomic, retain) IBOutlet UITextField* date;

@property (nonatomic, retain) IBOutlet UITextView* memo;

@property (nonatomic, retain) IBOutlet UILabel* orderLabel;
@property (nonatomic, retain) IBOutlet UITextField* orderTextField;
@property (nonatomic,retain) NSString* orderHeaderIUR;
@property (nonatomic,retain) NSString* orderNumber;
@property (nonatomic,assign) BOOL screenLoadedFlag;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) IBOutlet UILabel* employeeLabel;
@property (nonatomic, retain) IBOutlet UILabel* typeLabel;
@property (nonatomic, retain) IBOutlet UILabel* contactLabel;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;


-(IBAction)donePressed:(id)sender;

@end
