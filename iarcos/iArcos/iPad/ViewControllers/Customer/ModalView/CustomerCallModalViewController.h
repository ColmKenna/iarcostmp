//
//  CustomerCallModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCallTableCell.h"
#import "CustomerCallDetailViewController.h"
#import "CallGenericServices.h"
#import "ArcosCustomiseAnimation.h"
#import "ConnectivityCheck.h"


@interface CustomerCallModalViewController : UITableViewController <GetDataGenericDelegate,SlideAcrossViewAnimationDelegate,ArcosCustomiseAnimationDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UIView* tableHeader;
    NSMutableArray* displayList;
//    UIActivityIndicatorView* activityIndicator;
    NSNumber* locationIUR;
    CallGenericServices* callGenericServices;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    NSNumber* _locationDefaultContactIUR;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) UIViewController* rootView;
@property (nonatomic, retain) NSNumber* locationDefaultContactIUR;


-(void)closePressed:(id)sender;
-(void)totalsPressed:(id)sender;
-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender;

@end
