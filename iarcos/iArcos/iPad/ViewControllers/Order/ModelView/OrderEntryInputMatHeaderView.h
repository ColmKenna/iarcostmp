//
//  OrderEntryInputMatHeaderView.h
//  iArcos
//
//  Created by Apple on 15/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface OrderEntryInputMatHeaderView : UIView {
    LeftBlueSeparatorUILabel* _qty;
    LeftBlueSeparatorUILabel* _bon;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* qty;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* bon;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end

