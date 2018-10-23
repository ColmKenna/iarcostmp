//
//  PresenterCombinedSlideViewBaseItemController.h
//  iArcos
//
//  Created by David Kilmartin on 28/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterCombinedSlideViewItemDelegate.h"

@interface PresenterCombinedSlideViewBaseItemController : UIViewController {
    id<PresenterCombinedSlideViewItemDelegate> _itemDelegate;
}

@property(nonatomic, assign) id<PresenterCombinedSlideViewItemDelegate> itemDelegate;

- (void)loadContentWithPath:(NSString*)aPath;

@end
