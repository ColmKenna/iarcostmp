//
//  CustomerNotBuyHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 03/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerNotBuyHeaderView : UIView {
    UILabel* _descriptionTitleLabel;   
}

@property(nonatomic, retain) IBOutlet UILabel* descriptionTitleLabel;

@end
