//
//  CustomerGroupBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerGroupContactTableViewCellDelegate.h"

@interface CustomerGroupBaseTableViewCell : UITableViewCell {
    id<CustomerGroupContactTableViewCellDelegate> _actionDelegate;
    UILabel* _descLabel;
    UILabel* _contentLabel;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerGroupContactTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* descLabel;
@property(nonatomic, retain) IBOutlet UILabel* contentLabel;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)theData;

@end
