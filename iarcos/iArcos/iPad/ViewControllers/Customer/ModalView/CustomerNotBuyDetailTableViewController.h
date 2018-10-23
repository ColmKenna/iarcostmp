//
//  CustomerNotBuyDetailTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerNotBuyDetailHeaderView.h"
#import "CallGenericServices.h"
#import "CustomerNotBuyDetailTableCell.h"

@interface CustomerNotBuyDetailTableViewController : UITableViewController {
    CustomerNotBuyDetailHeaderView* _CNBDHV;
    CallGenericServices* _callGenericServices;
    NSNumber* _locationIUR;
    NSString* _levelCode;
    NSMutableArray* _displayList;
    NSNumber* _filterLevel;
}

@property(nonatomic, retain) IBOutlet CustomerNotBuyDetailHeaderView* CNBDHV;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSString* levelCode;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* filterLevel;

@end
