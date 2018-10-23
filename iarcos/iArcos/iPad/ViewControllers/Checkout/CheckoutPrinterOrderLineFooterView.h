//
//  CheckoutPrinterOrderLineFooterView.h
//  iArcos
//
//  Created by David Kilmartin on 15/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBlueSeparatorUILabel.h"
#import "HorizontalBlueSeparatorUILabel.h"

@interface CheckoutPrinterOrderLineFooterView : UIView {
    UILabel* _desc;
    LeftBlueSeparatorUILabel* _totalQty;
    LeftBlueSeparatorUILabel* _totalBon;
    HorizontalBlueSeparatorUILabel* _cellSeparator;

}

@property(nonatomic, retain) IBOutlet UILabel* desc;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* totalQty;
@property(nonatomic, retain) IBOutlet LeftBlueSeparatorUILabel* totalBon;
@property(nonatomic, retain) IBOutlet HorizontalBlueSeparatorUILabel* cellSeparator;

@end
