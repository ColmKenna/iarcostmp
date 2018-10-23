//
//  QueryOrderMemoWrapperViewController.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderMemoTableViewController.h"

@interface QueryOrderMemoWrapperViewController : UIViewController<CustomisePresentViewControllerDelegate, GenericRefreshParentContentDelegate, EditOperationViewControllerDelegate> {
    UIScrollView* _customiseScrollContentView;
    UIView* _customiseContentView;
    UINavigationController* _globalNavigationController;
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    id<EditOperationViewControllerDelegate> _editDelegate;
    NSString* _navgationBarTitle;
    NSString* _actionType;
    NSNumber* _IUR;
    NSNumber* _locationIUR;
    NSNumber* _taskIUR;
    NSNumber* _contactIUR;
    NSNumber* _memoEmployeeIUR;
    NSString* _taskCompletionDate;
    
    NSIndexPath* _taskCurrentIndexPath;
}

@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property (nonatomic, assign) id<EditOperationViewControllerDelegate> editDelegate;
@property (nonatomic,retain) NSString* navgationBarTitle;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic,retain) NSNumber* IUR;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSNumber* taskIUR;
@property (nonatomic,retain) NSNumber* contactIUR;
@property (nonatomic,retain) NSNumber* memoEmployeeIUR;
@property (nonatomic,retain) NSString* taskCompletionDate;
@property (nonatomic,retain) NSIndexPath* taskCurrentIndexPath;

@end
