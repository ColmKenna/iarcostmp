//
//  StockistChildTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 17/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
@protocol StockistChildTableViewDelegate;

@interface StockistChildTableViewController : UITableViewController {
    NSMutableArray* _displayList;
    id<StockistChildTableViewDelegate> _childDelegate;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) id<StockistChildTableViewDelegate> childDelegate;

- (void)descrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode;

@end

@protocol StockistChildTableViewDelegate <NSObject>

- (void)didSelectStockistChildWithCellData:(NSDictionary*)aCellData;

@end
