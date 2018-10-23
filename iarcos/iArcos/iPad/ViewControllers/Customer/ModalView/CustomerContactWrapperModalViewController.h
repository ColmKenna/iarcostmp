//
//  CustomerContactWrapperModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactModalViewController.h"
#import "ModelViewDelegate.h"
#import "GenericRefreshParentContentDelegate.h"

@interface CustomerContactWrapperModalViewController : UIViewController<ModelViewDelegate, GenericRefreshParentContentDelegate,CustomisePresentViewControllerDelegate,CustomerInfoAccessTimesCalendarTableViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ModelViewDelegate> delegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    IBOutlet UIView* customiseContentView;
    IBOutlet UIScrollView* customiseScrollContentView;
    UINavigationController* _globalNavigationController;
    NSNumber* _locationIUR;
    NSString* _navgationBarTitle;
    NSMutableDictionary* _tableCellData;
    NSString* _actionType;
    id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> _actionDelegate;
}

@property (nonatomic,assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic,assign) id<ModelViewDelegate> delegate;
@property (nonatomic,assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSString* navgationBarTitle;
@property (nonatomic,retain) NSMutableDictionary* tableCellData;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic,assign) id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> actionDelegate;
@end
