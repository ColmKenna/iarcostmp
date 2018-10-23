//
//  CustomerInfoAccountBalanceDetailTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoAccountBalanceDetailTableViewCell : UITableViewCell {
    UILabel* _infoTitle;
    UILabel* _infoValue;
}

@property(nonatomic, retain) IBOutlet UILabel* infoTitle;
@property(nonatomic, retain) IBOutlet UILabel* infoValue;

@end
