//
//  SmallL5L3SearchFormRowSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallL5L3SearchFormRowDataManager.h"

@interface SmallL5L3SearchFormRowSlideViewController : UIViewController<SmallImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    SmallL5L3SearchFormRowDataManager* _smallL5L3SearchFormRowDataManager;
    id<SmallImageSlideViewItemDelegate> _delegate;
}
@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) SmallL5L3SearchFormRowDataManager* smallL5L3SearchFormRowDataManager;
@property(nonatomic, retain) id<SmallImageSlideViewItemDelegate> delegate;

@end
