//
//  CustomerContactInfoTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "CustomerContactInfoTableCell.h"
#import "CustomerContactWrapperModalViewController.h"
#import "ModelViewDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomerAccessTimesUtils.h"
#import "ArcosMailWrapperViewController.h"

@interface CustomerContactInfoTableViewController : UITableViewController <ModelViewDelegate, CustomerContactEmailDelegate, MFMailComposeViewControllerDelegate, GenericRefreshParentContentDelegate,CustomisePresentViewControllerDelegate,GetDataGenericDelegate,CustomerInfoAccessTimesCalendarTableViewControllerDelegate,ArcosMailTableViewControllerDelegate> {
    NSNumber* _locationIUR;
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    NSMutableDictionary* _aCustDict;
    UIView* tableHeader;
    CallGenericServices* _callGenericServices;
    CustomerContactTypesDataManager* _customerContactTypesDataManager;
    ArcosGenericReturnObject* _contactGenericReturnObject;
    NSString* _myArcosAdminEmail;
    NSString* _emailActionType;
    NSNumber* _emailContactIUR;
    CustomerAccessTimesUtils* _customerAccessTimesUtils;
}

@property (nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* originalDisplayList;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) NSMutableDictionary* aCustDict;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) CustomerContactTypesDataManager* customerContactTypesDataManager;
@property (nonatomic, retain) ArcosGenericReturnObject* contactGenericReturnObject;
@property (nonatomic, retain) NSString* myArcosAdminEmail;
@property (nonatomic, retain) NSString* emailActionType;
@property (nonatomic, retain) NSNumber* emailContactIUR;
@property (nonatomic, retain) CustomerAccessTimesUtils* customerAccessTimesUtils;

//- (BOOL)checkCanSendEmailStatus;
- (void)createEmailComposeViewControllerWithType:(NSString*)anEmailActionType;

@end
