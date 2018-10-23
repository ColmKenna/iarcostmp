//
//  CustomerInvoiceModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomerInvoiceDetailsModalViewController.h"
#import "CustomerInvoiceTableCell.h"
#import "CallGenericServices.h"
#import "ArcosCustomiseAnimation.h"
#import "ConnectivityCheck.h"
#import "CustomerIarcosInvoiceTableCell.h"
#import "UIViewController+ArcosStackedController.h"
#import "CustomerIarcosInvoiceDetailsTableViewController.h"
#import "ArcosDateRangeProcessor.h"

@interface CustomerInvoiceModalViewController : UITableViewController <GetDataGenericDelegate,ArcosCustomiseAnimationDelegate>{
//    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
    NSNumber* locationIUR;
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
}

//@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) UIViewController* rootView;


-(void)closePressed:(id)sender;
-(void)totalsPressed:(id)sender;
-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender;

@end
