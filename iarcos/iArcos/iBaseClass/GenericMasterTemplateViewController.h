//
//  GenericMasterTemplateViewController.h
//  iArcos
//
//  Created by David Kilmartin on 22/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackedSplitDividerUILabel.h"
#import "GenericMasterTemplateDelegate.h"

@interface GenericMasterTemplateViewController : UIViewController<UIGestureRecognizerDelegate> {
    UIViewController* _masterViewController;
    StackedSplitDividerUILabel* _splitDividerUILabel;
    float _dividerWidth;
    id<GenericMasterTemplateDelegate> _myMoveDelegate;
}

@property(nonatomic, retain) UIViewController* masterViewController;
@property(nonatomic, retain) IBOutlet StackedSplitDividerUILabel* splitDividerUILabel;
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, assign) id<GenericMasterTemplateDelegate> myMoveDelegate;

- (void)layoutMySubviews;

@end
