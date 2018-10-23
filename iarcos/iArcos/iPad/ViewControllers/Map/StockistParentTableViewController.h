//
//  StockistParentTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 17/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "StockistChildTableViewController.h"

@interface StockistParentTableViewController : UITableViewController<StockistChildTableViewDelegate> {
    NSMutableArray* _displayList;
    id<StockistChildTableViewDelegate> _childDelegate;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) id<StockistChildTableViewDelegate> childDelegate;

- (void)getStockistParentData;
- (void)getDefaultStockistParentData;

@end
