//
//  DashboardVanStocksHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardVanStocksHeaderView : UIView {
    UILabel* _productCodeLabel;
    LeftBlueSeparatorUILabel* _descLabel;
    LeftBlueSeparatorUILabel* _productSizeLabel;
    LeftBlueSeparatorUILabel* _idealLabel;
    LeftBlueSeparatorUILabel* _inVanLabel;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* productCodeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* descLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* productSizeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* idealLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* inVanLabel;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
