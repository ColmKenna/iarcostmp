//
//  ProductDetailStockTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailStockTableCell : UITableViewCell {
    UILabel* _stockTitle;
    UILabel* _stockValue;
}

@property(nonatomic, retain) IBOutlet UILabel* stockTitle;
@property(nonatomic, retain) IBOutlet UILabel* stockValue;
@end
