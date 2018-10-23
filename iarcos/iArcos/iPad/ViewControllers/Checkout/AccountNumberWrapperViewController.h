//
//  AccountNumberWrapperViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountNumberTableViewController.h"


@interface AccountNumberWrapperViewController : UIViewController < ModelViewDelegate,GenericRefreshParentContentDelegate>{
    id<ModelViewDelegate> _delegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    UIView* _customiseContentView;
    UIScrollView* _customiseScrollContentView;
    UINavigationController* _globalNavigationController;
    NSNumber* _locationIUR;
    NSNumber* _fromLocationIUR;
}

@property(nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, retain) IBOutlet UIView* customiseContentView;
@property(nonatomic, retain) IBOutlet UIScrollView* customiseScrollContentView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSNumber* fromLocationIUR;

@end
