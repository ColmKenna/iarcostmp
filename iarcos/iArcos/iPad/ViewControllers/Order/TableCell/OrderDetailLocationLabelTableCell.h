//
//  OrderDetailLocationLabelTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "CustomerSelectionListingTableViewController.h"
#import "ArcosCoreData.h"

@interface OrderDetailLocationLabelTableCell : OrderDetailBaseTableCell <CustomerSelectionListingDelegate>{
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;


@end

