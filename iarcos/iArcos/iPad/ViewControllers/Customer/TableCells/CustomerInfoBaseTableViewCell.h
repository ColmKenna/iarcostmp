//
//  CustomerInfoBaseTableViewCell.h
//  iArcos
//
//  Created by Richard on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerInfoBaseTableViewCell : UITableViewCell {
    UILabel* _infoTitle;
    UILabel* _infoValue;
}

@property(nonatomic, retain) IBOutlet UILabel* infoTitle;
@property(nonatomic, retain) IBOutlet UILabel* infoValue;

@end


