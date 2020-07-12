//
//  OrderEntryInputRightHandSideFooterView.h
//  iArcos
//
//  Created by Apple on 03/07/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftRightInsetUILabel.h"
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface OrderEntryInputRightHandSideFooterView : UIView {
    LeftRightInsetUILabel* _totalLabel;
    LeftBlueSeparatorUILabel* _totalInStock;
    LeftBlueSeparatorUILabel* _totalFoc;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet LeftRightInsetUILabel* totalLabel;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* totalInStock;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* totalFoc;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end


