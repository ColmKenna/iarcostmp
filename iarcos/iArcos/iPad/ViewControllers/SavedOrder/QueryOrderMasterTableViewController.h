//
//  QueryOrderMasterTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "QueryOrderMasterTableCell.h"
#import "ArcosXMLParser.h"
#import "QueryOrderTaskWrapperViewController.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "CustomerDetailsWrapperModalViewController.h"
#import "ArcosCustomiseAnimation.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "QueryOrderEmailProcessCenter.h"
#import "UIViewController+ArcosStackedController.h"
#import "QueryOrderDetailTableViewController.h"
#import "ArcosMailWrapperViewController.h"

@protocol QueryOrderMasterTableViewControllerDelegate <NSObject>
- (void)selectQueryOrderMasterRecord:(NSNumber*)taskIUR;
//- (CGRect)getParentFrameFromChild;
- (NSMutableArray*)getQueryOrderDetailDataList;
- (void)clearDetailTableCellList;
@end

typedef enum {
    QueryOrderListings = 0,
    QueryOrderHomePage,
    QueryOrderDashboard
} QueryOrderSource;

typedef enum {
    RefreshRequestListings = 0,
    RefreshRequestHomePage,
    RefreshRequestAdd,
    RefreshRequestEdit
} RefreshRequestSource;

typedef enum {
    MasterInputRequestSourceDefault = 0,
    MasterInputRequestSourceDashboard
} MasterInputRequestSource;

@interface QueryOrderMasterTableViewController : UITableViewController<QueryOrderMasterTableCellDelegate, ModelViewDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate, CustomisePresentViewControllerDelegate, GenericRefreshParentContentDelegate,EditOperationViewControllerDelegate,QueryOrderMasterTableViewControllerDelegate,QueryOrderDetailTableViewControllerDelegate, ArcosMailTableViewControllerDelegate> {
    id<QueryOrderMasterTableViewControllerDelegate> _delegate;
    NSMutableArray* _displayList;
    NSMutableArray* _heightList;
    CallGenericServices* _callGenericServices;
    UIBarButtonItem* _addButton;
    UIBarButtonItem* _emailButton;
    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    NSMutableArray* _rightBarButtonItemList;
    QueryOrderTaskTableViewController* _queryOrderTaskTableViewController;
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
    QueryOrderSource _queryOrderSource;
    RefreshRequestSource _refreshRequestSource;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UIView* _myParentNavigationControllerView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    MFMailComposeViewController* _mailController;
    NSNumber* _locationIUR;
    BOOL _isNotFirstLoaded;
    NSInteger _taskTypeInstance;
    QueryOrderEmailProcessCenter* _queryOrderEmailProcessCenter;
    NSString* _atomicSqlFieldString;
    NSString* _prefixSqlString;
    NSIndexPath* _currentIndexPath;
    float _textViewContentWidth;
    NSString* _ownLocationPrefixSqlString;
    BOOL _isIssueClosedChanged;
    BOOL _issueClosedActualValue;
    NSString* _defaultComletionDateString;
    MasterInputRequestSource _masterInputRequestSource;
}

@property(nonatomic, assign) id<QueryOrderMasterTableViewControllerDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* heightList;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) UIBarButtonItem* addButton;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic, retain) NSMutableArray* rightBarButtonItemList;
@property(nonatomic, retain) QueryOrderTaskTableViewController* queryOrderTaskTableViewController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, assign) QueryOrderSource queryOrderSource;
@property(nonatomic, assign) RefreshRequestSource refreshRequestSource;
@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) UIView* myParentNavigationControllerView;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, assign) NSInteger taskTypeInstance;
@property(nonatomic,retain) QueryOrderEmailProcessCenter* queryOrderEmailProcessCenter;
@property(nonatomic,retain) NSString* atomicSqlFieldString;
@property(nonatomic,retain) NSString* prefixSqlString;
@property(nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nonatomic, assign) float textViewContentWidth;
@property(nonatomic,retain) NSString* ownLocationPrefixSqlString;
@property(nonatomic,assign) BOOL isIssueClosedChanged;
@property(nonatomic,assign) BOOL issueClosedActualValue;
@property(nonatomic,retain) NSString* defaultComletionDateString;
@property(nonatomic,assign) MasterInputRequestSource masterInputRequestSource;

- (void)loadDataByTaskType:(NSInteger)taskType;
- (void)loadDataByRequestSource;


@end
