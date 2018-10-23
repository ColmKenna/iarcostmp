//
//  NextCheckoutOrderInfoTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 29/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "NextCheckoutTableViewCellFactory.h"
#import "NextCheckoutOrderInfoHeaderView.h"
#import "NextCheckoutOrderInfoDelegate.h"
#import "ArcosConfigDataManager.h"

@interface NextCheckoutOrderInfoTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NextCheckoutBaseTableViewCellDelegate> {
    id<NextCheckoutOrderInfoDelegate> _orderInfoDelegate;
    NSMutableDictionary* _orderHeader;
    NSMutableDictionary* _groupedDataDict;
    NSMutableArray* _sectionTitleList;
    NSString* _orderDetailsTitle;
    NSString* _contactDetailsTitle;
    NSString* _commentsTitle;
    NSString* _followUpTitle;
    NSNumber* _placeHolderNumber;
    NextCheckoutTableViewCellFactory* _tableCellFactory;
}

@property(nonatomic, assign) id<NextCheckoutOrderInfoDelegate> orderInfoDelegate;
@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSString* orderDetailsTitle;
@property(nonatomic, retain) NSString* contactDetailsTitle;
@property(nonatomic, retain) NSString* commentsTitle;
@property(nonatomic, retain) NSString* followUpTitle;
@property(nonatomic, retain) NSNumber* placeHolderNumber;
@property(nonatomic, retain) NextCheckoutTableViewCellFactory* tableCellFactory;

- (void)createBasicDataWithOrderHeader:(NSMutableDictionary*)anOrderHeader;

@end
