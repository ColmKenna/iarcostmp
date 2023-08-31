//
//  CustomerNotBuyModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "CustomerNotBuyTableCell.h"
#import "ArcosUtils.h"
#import "ConnectivityCheck.h"
#import "MBProgressHUD.h"
#import "WidgetFactory.h"
#import "SlideAcrossViewAnimationDelegate.h"
@class ArcosRootViewController;
#import "ArcosCustomiseAnimation.h"
#import "CustomerNotBuyDetailTableViewController.h"
#import "CustomerNotBuyHeaderView.h"

@interface CustomerNotBuyModalViewController : UITableViewController <GetDataGenericDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate,ArcosCustomiseAnimationDelegate,SlideAcrossViewAnimationDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;    
    CustomerNotBuyHeaderView* _notBuyHeaderView;
    NSMutableArray* displayList;
//    UIActivityIndicatorView* activityIndicator;
    NSNumber* locationIUR;
    CallGenericServices* callGenericServices;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
//    MBProgressHUD* HUD;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSMutableArray* _formDetailList;
    UIBarButtonItem* formButton;
    NSNumber* _defaultFormIUR;
    NSString* _parentContentString;
    UINavigationController* _globalNavigationController;
    ArcosRootViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    NSNumber* _currentProductLevel;
    BOOL _isFirstLevel;
    NSString* _levelCode;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet CustomerNotBuyHeaderView* notBuyHeaderView;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property(nonatomic,retain) WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic,retain) NSMutableArray* formDetailList;    
@property(nonatomic,retain) UIBarButtonItem* formButton;
@property(nonatomic,retain) NSNumber* defaultFormIUR;
@property(nonatomic,retain) NSString* parentContentString;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) ArcosRootViewController* rootView;
@property (nonatomic, retain) NSNumber* currentProductLevel;
@property (nonatomic, assign) BOOL isFirstLevel;
@property (nonatomic, retain) NSString* levelCode;

-(void)closePressed:(id)sender;
-(void)startCallService;
-(void)formPressed:(id)sender;
-(NSString*)formDetailDescWithFormIUR:(NSNumber*)anFormIUR;

@end
