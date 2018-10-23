//
//  SavedIarcosOrderDetailControlTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedIarcosOrderDetailControlTableViewCell : UITableViewCell {
    UIButton* _controlButton;
    UILabel* _controlLabel;
}

@property(nonatomic, retain) IBOutlet UIButton* controlButton;
@property(nonatomic, retain) IBOutlet UILabel* controlLabel;

@end
