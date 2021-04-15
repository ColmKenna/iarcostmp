//
//  ProductSelectionListingTableViewCell.h
//  iArcos
//
//  Created by Richard on 14/04/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductSelectionListingTableViewCell : UITableViewCell {
//    UILabel* _orderPadDetailsLabel;
    UILabel* _productCode;
    UILabel* _descriptionLabel;
}

//@property(nonatomic, retain) IBOutlet UILabel* orderPadDetailsLabel;
@property(nonatomic, retain) IBOutlet UILabel* productCode;
@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;

@end

