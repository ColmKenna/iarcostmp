//
//  OrderDetailBaseTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailTypesTableCellDelegate.h"

@interface OrderDetailBaseTableCell : UITableViewCell {
    id<OrderDetailTypesTableCellDelegate> _delegate;
    NSMutableDictionary* _cellData;
    NSIndexPath* _indexPath;
    BOOL _isNotEditable;
}

@property(nonatomic, assign) id<OrderDetailTypesTableCellDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, assign) BOOL isNotEditable;

- (void)configCellWithData:(NSMutableDictionary*)theData;

@end
