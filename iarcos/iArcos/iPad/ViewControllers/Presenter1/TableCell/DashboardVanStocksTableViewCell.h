//
//  DashboardVanStocksTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 16/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardVanStocksTableViewCell : UITableViewCell  {
    UILabel* _productCodeLabel;
    LeftBlueSeparatorUILabel* _descLabel;
    LeftBlueSeparatorUILabel* _productSizeLabel;
    LeftBlueSeparatorUILabel* _stockOnOrderLabel;
    LeftBlueSeparatorUILabel* _stockOnHandLabel;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* productCodeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* descLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* productSizeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* stockOnOrderLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* stockOnHandLabel;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
