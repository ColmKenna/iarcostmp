//
//  CustomerOrderModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 28/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerOrderTableCell.h"
#import "CustomerOrderDetailsModalViewController.h"
#import "CallGenericServices.h"
#import "ArcosCustomiseAnimation.h"
#import "ConnectivityCheck.h"
#import "SlideAcrossViewAnimationDelegate.h"


@interface CustomerOrderModalViewController : UITableViewController <GetDataGenericDelegate,SlideAcrossViewAnimationDelegate,ArcosCustomiseAnimationDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UILabel* _numberTitleLabel;
    UILabel* _dateTitleLabel;
    UILabel* _wholesalerTitleLabel;
    UILabel* _valueTitleLabel;
    UILabel* _employeeTitleLabel;
    UILabel* _deliveryTitleLabel;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
//    UIActivityIndicatorView* activityIndicator;
    NSNumber* locationIUR;
    CallGenericServices* callGenericServices;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UILabel* numberTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* dateTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* wholesalerTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* valueTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* employeeTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* deliveryTitleLabel;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
//@property (nonatomic,retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) UIViewController* rootView;


-(void)closePressed:(id)sender;
-(void)totalsPressed:(id)sender;
-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender;

@end
