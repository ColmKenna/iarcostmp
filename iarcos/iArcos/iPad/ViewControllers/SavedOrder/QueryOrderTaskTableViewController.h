//
//  QueryOrderTaskTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 21/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "CallGenericServices.h"
#import "QueryOrderTaskDataManager.h"
#import "QueryOrderTaskTableCellFactory.h"
#import "ArcosCoreData.h"
#import "GenericRefreshParentContentDelegate.h"
#import "EditOperationViewControllerDelegate.h"
#import "QueryOrderTaskControlMemoTableCell.h"
#import "QueryOrderDetailTableCell.h"

@interface QueryOrderTaskTableViewController : UITableViewController<GetDataGenericDelegate, CustomerTypeTableCellDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    id<EditOperationViewControllerDelegate> _editDelegate;
    NSString* _actionType;
    NSNumber* _IUR;
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    QueryOrderTaskDataManager* _queryOrderTaskDataManager;
    QueryOrderTaskTableCellFactory* _cellFactory;
    int _employeeSecurityLevel;
    NSString* _employeeName;
    NSNumber* _locationIUR;
    NSNumber* _contactIUR;
    NSIndexPath* _processingIndexPath;
    QueryOrderTaskControlMemoTableCell* _queryOrderTaskControlMemoTableCell;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, assign) id<EditOperationViewControllerDelegate> editDelegate;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic,retain) NSNumber* IUR;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic,retain) QueryOrderTaskDataManager* queryOrderTaskDataManager;
@property (nonatomic,retain) QueryOrderTaskTableCellFactory* cellFactory;
@property (nonatomic, assign) int employeeSecurityLevel;
@property (nonatomic,retain) NSString* employeeName;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSNumber* contactIUR;
@property (nonatomic,retain) NSIndexPath* processingIndexPath;
@property (nonatomic,retain) IBOutlet QueryOrderTaskControlMemoTableCell* queryOrderTaskControlMemoTableCell;

-(int)getEmployeeSecurityLevel;
-(void)submitChangedDataList;
-(void)endOnSaveAction;


@end
