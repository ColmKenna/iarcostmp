//
//  CustomerIarcosInvoiceDetailsTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerIarcosInvoiceDetailsDataManager.h"
#import "CustomerInfoHeaderViewController.h"
#import "CallGenericServices.h"
#import "CustomerIarcosInvoiceDetailsCellFactory.h"
#import "OrderlinesIarcosTableViewController.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface CustomerIarcosInvoiceDetailsTableViewController : UITableViewController<GetDataGenericDelegate, OrderDetailTypesTableCellDelegate,SlideAcrossViewAnimationDelegate> {
    CustomerInfoHeaderViewController* _customerInfoHeaderViewController;
    CustomerIarcosInvoiceDetailsDataManager* _customerIarcosInvoiceDetailsDataManager;
    CallGenericServices* _callGenericServices;
    CustomerIarcosInvoiceDetailsCellFactory* _invoiceDetailsCellFactory;
    NSNumber* _locationIUR;
    BOOL _screenLoadedFlag;
    UINavigationController* _globalNavigationController;
}

@property(nonatomic, retain) CustomerInfoHeaderViewController* customerInfoHeaderViewController;
@property(nonatomic, retain) CustomerIarcosInvoiceDetailsDataManager* customerIarcosInvoiceDetailsDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) CustomerIarcosInvoiceDetailsCellFactory* invoiceDetailsCellFactory;
@property(nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic,assign) BOOL screenLoadedFlag;
@property (nonatomic,retain) UINavigationController* globalNavigationController;

@end
