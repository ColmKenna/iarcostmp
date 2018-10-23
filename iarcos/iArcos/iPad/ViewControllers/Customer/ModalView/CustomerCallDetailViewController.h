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

@interface CustomerCallDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetDataGenericDelegate> {
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



-(IBAction)donePressed:(id)sender;

@end
