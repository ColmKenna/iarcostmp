//
//  CheckoutPrinterOrderLineHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 12/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface CheckoutPrinterOrderLineHeaderView : UIView {
    UILabel* _desc;
    LeftBlueSeparatorUILabel* _qty;
    LeftBlueSeparatorUILabel* _bon;
    HorizontalBlueSeparatorUILabel* _cellSeparator;
}

@property(nonatomic, retain) IBOutlet UILabel* desc;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* qty;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* bon;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
