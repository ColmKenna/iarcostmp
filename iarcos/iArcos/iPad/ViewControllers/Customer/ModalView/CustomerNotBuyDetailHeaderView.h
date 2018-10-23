//
//  CustomerNotBuyDetailHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerNotBuyDetailHeaderView : UIView {
    UILabel* _detailsTitleLabel;
    UILabel* _lastOrderedTitleLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* detailsTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* lastOrderedTitleLabel;

@end
