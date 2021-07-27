//
//  AccountNumberTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "AccountNumberTableCell.h"
#import "ArcosCoreData.h"
#import "ArcosConfigDataManager.h"


@interface AccountNumberTableViewController : UITableViewController<GenericTextViewInputTableCellDelegate> {
    id<ModelViewDelegate> _delegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    NSMutableArray* _displayList;
    NSNumber* _locationIUR;
    NSNumber* _fromLocationIUR;
    NSString* _wholesalerLocationCode;
    NSString* _wholesalerLocationName;
}

@property(nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSNumber* fromLocationIUR;
@property(nonatomic, retain) NSString* wholesalerLocationCode;
@property(nonatomic, retain) NSString* wholesalerLocationName;

- (void)populateLocLocLink:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR customerCode:(NSString*)aCustomerCode LocLocLink:(LocLocLink*)LocLocLink;

@end
