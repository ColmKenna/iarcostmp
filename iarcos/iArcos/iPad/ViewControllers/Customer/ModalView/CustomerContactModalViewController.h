//
//  CustomerContactModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "ArcosUtils.h"
#import "CallGenericServices.h"
#import "SettingManager.h"
#import <QuartzCore/QuartzCore.h>
#import "ModelViewDelegate.h"
#import "CustomerContactTableCell.h"
#import "GenericRefreshParentContentDelegate.h"
#import "CustomerFlagTableCell.h"
#import "CustomerContactTypesDataManager.h"
#import "CustomerContactTypesTableCellFactory.h"
#import "CustomerContactLinksTableCell.h"
#import "CustomerContactLinkHeaderViewController.h"
#import "ActivateAppStatusManager.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "CustomerDetailsContactAccessTimesTableViewCell.h"
#import "CustomerAccessTimesUtils.h"

@interface CustomerContactModalViewController : UITableViewController <UIPopoverControllerDelegate, GetDataGenericDelegate, UIAlertViewDelegate, UITextFieldDelegate, CustomerContactInputDelegate,CustomerTypeTableCellDelegate, CustomerContactLinkHeaderViewControllerDelegate, UIActionSheetDelegate, CustomerInfoAccessTimesCalendarTableViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ModelViewDelegate> _delegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    NSNumber* _locationIUR;
    NSNumber* _titleTypeIUR;
//    UIPopoverController* _globalPopoverController;
    NSNumber* _contactTypeIUR;
    UILabel* currentLabel;
    int currentControlTag;
    
    //    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    NSMutableArray* _fieldValueList;
    NSMutableArray* _fieldNameList;
    
    
    IBOutlet UITableView* recordTableView;
    
    
    ArcosCreateRecordObject* arcosCreateRecordObject;
    
    NSMutableDictionary* _tableCellData;
    int rowPointer;
    UIBarButtonItem* submitButton;
    NSString* _actionType;
    
    ArcosGenericClass* _contactGenericClass;
    CustomerContactTypesDataManager* _customerContactTypesDataManager;
    CustomerContactTypesTableCellFactory* _cellFactory;
    ArcosGenericReturnObject* _contactGenericReturnObject;
    NSNumber* _contactIUR;
    
    //for update button
    NSMutableArray* _changedDataArray;
    NSString* _changedFieldName;
    NSString* _changedActualContent;
    BOOL _isNotFirstLoaded;
    int _employeeSecurityLevel;
    NSNumber* _brandNewContactIUR;    
    UIBarButtonItem* _deleteLinkButton;
    CustomerContactLinkHeaderViewController* _CCLHVC;
    CustomerAccessTimesUtils* _customerAccessTimesUtils;
    NSMutableDictionary* _contactDict;
    id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> _actionDelegate;
}

@property (nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property (nonatomic, assign) id<ModelViewDelegate> delegate;
@property (nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property(nonatomic,retain) NSNumber* titleTypeIUR;
//@property(nonatomic,retain) UIPopoverController* globalPopoverController;
@property(nonatomic,retain) NSNumber* contactTypeIUR;
@property(nonatomic,retain) NSMutableArray* fieldValueList;
@property(nonatomic,retain) NSMutableArray* fieldNameList;
@property (nonatomic,retain) NSString* actionType;

@property (nonatomic,retain) IBOutlet UITableView* recordTableView;

@property (nonatomic,retain) NSMutableDictionary* tableCellData;
@property (nonatomic,retain) UIBarButtonItem* submitButton;

@property (nonatomic,retain) ArcosGenericClass* contactGenericClass;
@property (nonatomic,retain) CustomerContactTypesDataManager* customerContactTypesDataManager;
@property (nonatomic,retain) CustomerContactTypesTableCellFactory* cellFactory;
@property (nonatomic,retain) ArcosGenericReturnObject* contactGenericReturnObject;
@property (nonatomic,retain) NSNumber* contactIUR;
@property (nonatomic,retain) NSMutableArray* changedDataArray;
@property (nonatomic,retain) NSString* changedFieldName;
@property (nonatomic,retain) NSString* changedActualContent;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) int employeeSecurityLevel;
@property (nonatomic,retain) NSNumber* brandNewContactIUR;
@property (nonatomic,retain) UIBarButtonItem* deleteLinkButton;
@property (nonatomic,retain) CustomerContactLinkHeaderViewController* CCLHVC;
@property (nonatomic,retain) CustomerAccessTimesUtils* customerAccessTimesUtils;
@property (nonatomic,retain) NSMutableDictionary* contactDict;
@property (nonatomic, assign) id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> actionDelegate;

- (void)submitProcessCenter;
- (void)submitChangedDataList:(NSMutableArray*)aChangedDataList;
- (int)getEmployeeSecurityLevel;
- (void)endOnSaveAction;
- (void)deleteLinkPressed:(id)sender;
- (void)scrollToLinkSection;

@end
