//
//  PriceChangeBaseTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceChangeBaseTableCellDelegate.h"

@interface PriceChangeBaseTableCell : UITableViewCell {
    id<PriceChangeBaseTableCellDelegate> _delegate;
    UILabel* _fieldNameLabel;    
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<PriceChangeBaseTableCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)aDataDict;

@end
