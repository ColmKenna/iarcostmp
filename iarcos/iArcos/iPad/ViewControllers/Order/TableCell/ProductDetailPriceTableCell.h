//
//  ProductDetailPriceTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 13/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailPriceTableCell : UITableViewCell {
    UILabel* _priceTitle;
    UILabel* _priceValue;    
}

@property(nonatomic, retain) IBOutlet UILabel* priceTitle;
@property(nonatomic, retain) IBOutlet UILabel* priceValue;

@end
