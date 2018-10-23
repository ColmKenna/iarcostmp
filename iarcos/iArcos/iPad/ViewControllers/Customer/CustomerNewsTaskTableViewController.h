//
//  CustomerNewsTaskTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "CallGenericServices.h"
#import "CustomerNewsTaskTableCell.h"
#import "ArcosXMLParser.h"
#import "SettingManager.h"
#import "QueryOrderTaskWrapperViewController.h"
typedef enum {
    CustomerNewsTaskNormal = 0,
    CustomerNewsTaskDashboard
} CustomerNewsTaskRequestSource;

@interface CustomerNewsTaskTableViewController : UITableViewController<GetDataGenericDelegate, CustomerNewsTaskTableCellDelegate, CustomisePresentViewControllerDelegate,GenericRefreshParentContentDelegate> {
    CustomerNewsTaskRequestSource _customerNewsTaskRequestSource;
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    NSMutableArray* _displayList;
    NSMutableArray* _heightList;
    NSMutableArray* _typeList;
    float _textViewContentWidth;
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
}

@property(nonatomic, assign) CustomerNewsTaskRequestSource customerNewsTaskRequestSource;
@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* heightList;
@property(nonatomic, retain) NSMutableArray* typeList;
@property(nonatomic, assign) float textViewContentWidth;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* myRootViewController;

@end
