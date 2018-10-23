//
//  QueryOrderDetailTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "QueryOrderDetailTableCell.h"
#import "ArcosXMLParser.h"
#import "QueryOrderMemoWrapperViewController.h"

@protocol QueryOrderDetailTableViewControllerDelegate <NSObject>
- (NSIndexPath*)getMasterTaskSelectedRow;
- (NSNumber*)getMasterTaskLocationIUR;
- (NSNumber*)getMasterTaskIUR;
- (NSNumber*)getMasterTaskContactIUR;
- (NSString*)getMasterTaskCompletionDate;
- (void)refreshMasterContentByMemoCreate:(NSIndexPath*)anIndexPath;
- (void)inheritEditFinishedWithData:(id)contentString fieldName:(NSString *)fieldName forIndexpath:(NSIndexPath *)theIndexpath;
@end

typedef enum {
    QueryOrderDetailListings = 0,
    QueryOrderDetailHomePage
} QueryOrderDetailSource;

typedef enum {
    DetailInputRequestSourceDefault = 0,
    DetailInputRequestSourceDashboard
} DetailInputRequestSource;

@interface QueryOrderDetailTableViewController : UITableViewController<CustomisePresentViewControllerDelegate, GenericRefreshParentContentDelegate, GenericDoubleTapRecordDelegate, EditOperationViewControllerDelegate> {
    id<QueryOrderDetailTableViewControllerDelegate> _delegate;
    QueryOrderDetailSource _queryOrderDetailSource;
    BOOL _isNotFirstLoaded;
    CallGenericServices* _callGenericServices;
    NSMutableArray* _displayList;
    NSMutableArray* _heightList;
    UIBarButtonItem* _addButton;
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
    UIView* _myParentNavigationControllerView;
    NSNumber* _taskIUR;
    float _textViewContentWidth;
    DetailInputRequestSource _detailInputRequestSource;
}

@property(nonatomic, assign) id<QueryOrderDetailTableViewControllerDelegate> delegate;
@property(nonatomic, assign) QueryOrderDetailSource queryOrderDetailSource;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* heightList;
@property(nonatomic, retain) UIBarButtonItem* addButton;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, retain) UIView* myParentNavigationControllerView;
@property(nonatomic, retain) NSNumber* taskIUR;
@property(nonatomic, assign) float textViewContentWidth;
@property(nonatomic, assign) DetailInputRequestSource detailInputRequestSource;

- (void)loadDataForTableView:(NSNumber*)taskIUR;

@end
