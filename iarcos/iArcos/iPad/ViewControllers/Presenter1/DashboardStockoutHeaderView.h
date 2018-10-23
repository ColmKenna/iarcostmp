//
//  DashboardStockoutHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardStockoutHeaderView : UIView {
    UILabel* _productCodeLabel;
    LeftBlueSeparatorUILabel* _descLabel;
    LeftBlueSeparatorUILabel* _productSizeLabel;
    LeftBlueSeparatorUILabel* _onOrderLabel;
    LeftBlueSeparatorUILabel* _dueDateLabel;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* productCodeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* descLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* productSizeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* onOrderLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* dueDateLabel;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
