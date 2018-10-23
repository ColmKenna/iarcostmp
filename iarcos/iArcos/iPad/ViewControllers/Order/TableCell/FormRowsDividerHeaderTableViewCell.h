//
//  FormRowsDividerHeaderTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormRowsDividerHeaderTableViewCell : UITableViewCell {
    UILabel* _descLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* descLabel;

@end
