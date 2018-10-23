//
//  QueryOrderMemoTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "CallGenericServices.h"
#import "QueryOrderMemoDataManager.h"
#import "QueryOrderMemoCellFactory.h"
#import "ArcosCoreData.h"
#import "GenericRefreshParentContentDelegate.h"
#import "EditOperationViewControllerDelegate.h"

@interface QueryOrderMemoTableViewController : UITableViewController<GetDataGenericDelegate, CustomerTypeTableCellDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    id<EditOperationViewControllerDelegate> _editDelegate;
    NSString* _actionType;
    NSNumber* _IUR;
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    QueryOrderMemoDataManager* _queryOrderMemoDataManager;
    QueryOrderMemoCellFactory* _cellFactory;
    int _employeeSecurityLevel;
    NSString* _employeeName;
    NSNumber* _locationIUR;
    NSNumber* _taskIUR;
    NSNumber* _contactIUR;
    NSNumber* _memoEmployeeIUR;
    NSString* _taskCompletionDate;
    NSIndexPath* _taskCurrentIndexPath;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, assign) id<EditOperationViewControllerDelegate> editDelegate;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic,retain) NSNumber* IUR;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic,retain) QueryOrderMemoDataManager* queryOrderMemoDataManager;
@property (nonatomic,retain) QueryOrderMemoCellFactory* cellFactory;
@property (nonatomic, assign) int employeeSecurityLevel;
@property (nonatomic,retain) NSString* employeeName;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSNumber* taskIUR;
@property (nonatomic,retain) NSNumber* contactIUR;
@property (nonatomic,retain) NSNumber* memoEmployeeIUR;
@property (nonatomic,retain) NSString* taskCompletionDate;
@property (nonatomic,retain) NSIndexPath* taskCurrentIndexPath;

-(int)getEmployeeSecurityLevel;
-(void)submitChangedDataList;
-(void)endOnSaveAction;

@end
