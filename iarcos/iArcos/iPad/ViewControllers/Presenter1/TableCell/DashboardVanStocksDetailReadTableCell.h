//
//  DashboardVanStocksDetailReadTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksDetailBaseTableCell.h"
#import "ArcosUtils.h"

@interface DashboardVanStocksDetailReadTableCell : DashboardVanStocksDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField; 

@end
