//
//  OrderDetailContactControlTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 27/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailContactControlTableCell : UITableViewCell {
    UILabel* _controlLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* controlLabel;

@end
