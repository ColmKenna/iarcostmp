//
//  OrderEntryInputRightHandSideHeaderView.h
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftRightInsetUILabel.h"
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface OrderEntryInputRightHandSideHeaderView : UIView {
    LeftRightInsetUILabel* _orderDate;
    LeftBlueSeparatorUILabel* _inStock;
    LeftBlueSeparatorUILabel* _foc;
    LeftBlueSeparatorUILabel* _balance;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet LeftRightInsetUILabel* orderDate;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* inStock;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* foc;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* balance;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end


