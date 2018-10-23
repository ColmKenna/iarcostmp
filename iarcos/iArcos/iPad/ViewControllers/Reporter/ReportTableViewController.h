//
//  ReportTableViewController1.h
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "ReportTableCellProtocol.h"
#import "WidgetFactory.h"
#import "ReportCellFactory.h"
#import "CustomerDetailsWrapperModalViewController.h"
#import "ArcosCustomiseAnimation.h"
#import "CustomerContactWrapperModalViewController.h"
#import "CustomerCallDetailViewController.h"
#import "CustomerOrderDetailsModalViewController.h"
#import "CustomerInvoiceDetailsModalViewController.h"
#import "ReportMeetingWrapperViewController.h"
#import "ArcosMailWrapperViewController.h"

@interface ReportTableViewController : UITableViewController<UIPopoverControllerDelegate,WidgetFactoryDelegate,ModelViewDelegate,SlideAcrossViewAnimationDelegate, CustomisePresentViewControllerDelegate,GetDataGenericDelegate,MFMailComposeViewControllerDelegate,ArcosMailTableViewControllerDelegate>{
    CXMLDocument* ReportDocument;
    NSMutableArray* DisplayList;
    NSMutableArray* MainData;
    NSMutableArray* Options;
    NSMutableArray* Subtotal;
    IBOutlet UIView* headerView;
    ReportCellFactory* cellFactory;
    NSString* reportCode;
    NSString* reportCellIdentifier;
    
    //options
    WidgetFactory* _factory;
    NSMutableArray* optionList;
    NSMutableArray* sortList;
    UIPopoverController* _thePopover;
    
    //UIView animation
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    CallGenericServices* _callGenericServices;
    CustomerTypesDataManager* _customerTypesDataManager;
    NSString* _myArcosAdminEmail;
    CustomerContactTypesDataManager* _customerContactTypesDataManager;
    ArcosGenericReturnObject* _contactGenericReturnObject;
    NSString* _emailActionType;
    NSNumber* _emailContactIUR;
}
@property(nonatomic,retain) CXMLDocument* ReportDocument;
@property(nonatomic,retain) NSMutableArray* DisplayList;
@property(nonatomic,retain) NSMutableArray* MainData;
@property(nonatomic,retain) NSMutableArray* Options;
@property(nonatomic,retain) NSMutableArray* Subtotal;
@property(nonatomic,retain) IBOutlet UIView* headerView;
@property(nonatomic,retain) NSString* reportCode;


@property(nonatomic,retain) WidgetFactory* factory;
@property (nonatomic,retain)  NSMutableArray* optionList;
@property(nonatomic,retain) NSMutableArray* sortList;
@property (nonatomic,retain) UIPopoverController* thePopover;

@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) CustomerTypesDataManager* customerTypesDataManager;
@property (nonatomic, retain) NSString* myArcosAdminEmail;
@property (nonatomic, retain) CustomerContactTypesDataManager* customerContactTypesDataManager;
@property (nonatomic, retain) ArcosGenericReturnObject* contactGenericReturnObject;
@property (nonatomic, retain) NSString* emailActionType;
@property (nonatomic, retain) NSNumber* emailContactIUR;
@end
