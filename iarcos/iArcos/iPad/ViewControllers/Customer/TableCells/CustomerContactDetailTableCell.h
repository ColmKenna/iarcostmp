//
//  CustomerContactDetailTableCell.h
//  iArcos
//
//  Created by Richard on 12/10/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerContactDetailTableCell : UITableViewCell {
    UILabel* _nameLabel;
    UILabel* _addressLabel;
    UIButton* _cP09Button;
    UIButton* _cP10Button;
}

@property(nonatomic, retain) IBOutlet UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* addressLabel;
@property(nonatomic, retain) IBOutlet UIButton* cP09Button;
@property(nonatomic, retain) IBOutlet UIButton* cP10Button;


@end

