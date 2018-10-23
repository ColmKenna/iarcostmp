//
//  SmallFormDetailDividerSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallFormDetailDividerDataManager.h"


@interface SmallFormDetailDividerSlideViewController : UIViewController<SmallImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    SmallFormDetailDividerDataManager* _smallFormDetailDividerDataManager;
    id<SmallImageSlideViewItemDelegate> _delegate;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) SmallFormDetailDividerDataManager* smallFormDetailDividerDataManager;
@property(nonatomic, retain) id<SmallImageSlideViewItemDelegate> delegate;

@end
