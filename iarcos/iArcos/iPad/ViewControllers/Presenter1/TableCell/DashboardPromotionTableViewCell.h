//
//  DashboardPromotionTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface DashboardPromotionTableViewCell : UITableViewCell {
    UILabel* _productCodeLabel;
    LeftBlueSeparatorUILabel* _descLabel;
    LeftBlueSeparatorUILabel* _productSizeLabel;
    LeftBlueSeparatorUILabel* _bonusMinimumLabel;
    LeftBlueSeparatorUILabel* _bonusRequiredLabel;
    LeftBlueSeparatorUILabel* _bonusGivenLabel;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* productCodeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* descLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* productSizeLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* bonusMinimumLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* bonusRequiredLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* bonusGivenLabel;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
