//
//  CustomerTyvLyTableViewHeader.h
//  iArcos
//
//  Created by Apple on 06/07/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerTyvLyTableViewHeader : UIView {
    UILabel* _details;
    UILabel* _inStock;
    UILabel* _lYQty;
    UILabel* _lYBonus;
    UILabel* _lYValue;
    UILabel* _lYTDQty;
    UILabel* _lYTDBonus;
    UILabel* _lYTDValue;
    UILabel* _tYTDQty;
    UILabel* _tYTDBonus;
    UILabel* _tYTDValue;
    UILabel* _qty;
}

@property(nonatomic, retain) IBOutlet UILabel* details;
@property(nonatomic, retain) IBOutlet UILabel* inStock;
@property(nonatomic, retain) IBOutlet UILabel* lYQty;
@property(nonatomic, retain) IBOutlet UILabel* lYBonus;
@property(nonatomic, retain) IBOutlet UILabel* lYValue;
@property(nonatomic, retain) IBOutlet UILabel* lYTDQty;
@property(nonatomic, retain) IBOutlet UILabel* lYTDBonus;
@property(nonatomic, retain) IBOutlet UILabel* lYTDValue;
@property(nonatomic, retain) IBOutlet UILabel* tYTDQty;
@property(nonatomic, retain) IBOutlet UILabel* tYTDBonus;
@property(nonatomic, retain) IBOutlet UILabel* tYTDValue;
@property(nonatomic, retain) IBOutlet UILabel* qty;

@end

