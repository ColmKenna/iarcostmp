//
//  CustomerDetailsModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 03/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailsTableCell.h"
#import "CustomerPopoverMenuViewController.h"
#import "CustomerDetailsIURModalViewController.h"
#import "CustomerDetailsIURDelegate.h"
#import "CallGenericServices.h"
#import "ArcosUtils.h"
#import "CustomerTypesTableCellFactory.h"
#import "CustomerIURTableCell.h"
#import "CustomerTypeTableCellDelegate.h"
#import "CustomerTypesDataManager.h"
#import "ConnectivityCheck.h"
#import "ModelViewDelegate.h"
#import "GenericRefreshParentContentDelegate.h"
#import "ActivateAppStatusManager.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "CustomerContactLinkHeaderViewController.h"
#import "CustomerContactLinksTableCell.h"
#import "CustomerDetailsContactAccessTimesTableViewCell.h"
#import "CustomerAccessTimesUtils.h"

@interface CustomerDetailsModalViewController : UITableViewController <CustomerDetailsIURDelegate,GetDataGenericDelegate,CustomerTypeTableCellDelegate,UIAlertViewDelegate,CustomerContactLinkHeaderViewControllerDelegate,UIActionSheetDelegate,CustomerInfoAccessTimesCalendarTableViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ModelViewDelegate> delegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    CustomerTypesDataManager* customerTypesDataManager;
    NSNumber* locationIUR;
    NSMutableDictionary* _customerDict;
    IBOutlet UITableView* detailsListView; 
    UITextField* currentTextField;
    NSInteger currentRowIndex;
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;

    CustomerTypesTableCellFactory* cellFactory;
    CustomerDetailsIURModalViewController* cdimvc;
    
    //for update button
    NSMutableArray* _changedDataArray;
    NSString* _changedFieldName;
    NSString* _changedActualContent;
    int rowPointer;
    
    ArcosCreateRecordObject* arcosCreateRecordObject;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
        
    NSString* _actionType;
    BOOL _isNotFirstLoaded;
    int _employeeSecurityLevel;
    CustomerContactLinkHeaderViewController* _CCLHVC;
    UIBarButtonItem* _deleteLinkButton;
    CustomerAccessTimesUtils* _customerAccessTimesUtils;
    id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> _actionDelegate;
}

@property (nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic, assign) id<ModelViewDelegate> delegate;
@property (nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property (nonatomic,retain) NSMutableDictionary* customerDict;
@property (nonatomic,retain)  IBOutlet UITableView* detailsListView;
@property (nonatomic,retain) CustomerTypesTableCellFactory* cellFactory;
@property (nonatomic,retain) NSMutableArray* changedDataArray;
@property (nonatomic,retain) NSString* changedFieldName;
@property (nonatomic,retain) NSString* changedActualContent;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) int employeeSecurityLevel;
@property (nonatomic,retain) CustomerContactLinkHeaderViewController* CCLHVC;
@property (nonatomic,retain) UIBarButtonItem* deleteLinkButton;
@property (nonatomic,retain) CustomerAccessTimesUtils* customerAccessTimesUtils;
@property (nonatomic, assign) id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> actionDelegate;

-(void)closePressed:(id)sender;
-(void)updatePressed:(id)sender;
-(void)updateValue:(id)contentString actualContent:(id)actualContent withIndexPath:(NSIndexPath*)indexPath;
-(void)submitChangedDataList:(NSMutableArray*)aChangedDataList;
-(int)getEmployeeSecurityLevel;
-(void)endOnSaveAction;
-(BOOL)checkBeforeSubmit;


@end
