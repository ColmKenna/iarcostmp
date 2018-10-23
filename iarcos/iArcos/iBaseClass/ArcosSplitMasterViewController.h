//
//  ArcosSplitMasterViewController.h
//  iArcos
//
//  Created by David Kilmartin on 09/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitDividerUILabel.h"

@interface ArcosSplitMasterViewController : UIViewController<UIGestureRecognizerDelegate> {
    UIViewController* _masterViewController;
    SplitDividerUILabel* _splitDividerUILabel;
    float _dividerWidth;
}

@property(nonatomic, retain) UIViewController* masterViewController;
@property(nonatomic, retain) IBOutlet SplitDividerUILabel* splitDividerUILabel;
@property(nonatomic, assign) float dividerWidth;

- (void)layoutMySubviews;

@end
