//
//  ProductDetailLevelTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailLevelTableCell : UITableViewCell {
    UILabel* _levelTitle;
    UILabel* _levelValue;
}

@property(nonatomic, retain) IBOutlet UILabel* levelTitle;
@property(nonatomic, retain) IBOutlet UILabel* levelValue;

@end
