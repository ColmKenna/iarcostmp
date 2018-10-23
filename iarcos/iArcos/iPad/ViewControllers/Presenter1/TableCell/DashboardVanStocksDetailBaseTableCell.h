//
//  DashboardVanStocksDetailBaseTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksDetailTableCellDelegate.h"

@interface DashboardVanStocksDetailBaseTableCell : UITableViewCell {
    id<DashboardVanStocksDetailTableCellDelegate> _actionDelegate;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<DashboardVanStocksDetailTableCellDelegate> actionDelegate;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)aDataDict;

@end
