//
//  CustomerFlagModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "CustomerFlagTableCell.h"
#import "CustomerFlagDataManager.h"
#import "CallGenericServices.h"
#import "ConnectivityCheck.h"
#import "UIViewController+ArcosStackedController.h"

@interface CustomerFlagModalViewController : UITableViewController <GetDataGenericDelegate, GenericTextViewInputTableCellDelegate, UIAlertViewDelegate> {
    NSNumber* _locationIUR;
    CustomerFlagDataManager* _customerFlagDataManager;
    CallGenericServices* _callGenericServices;
    ConnectivityCheck* _connectivityCheck;
}

@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) CustomerFlagDataManager* customerFlagDataManager;
@property (nonatomic,retain) CallGenericServices* callGenericServices;
@property (nonatomic,retain) ConnectivityCheck* connectivityCheck;

@end
