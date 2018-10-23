//
//  FormRowsSubDividerHeaderTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 03/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormRowsSubDividerHeaderTableViewCell : UITableViewCell {
    UILabel* _descLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* descLabel;

@end
