//
//  SmallImageL5FormRowsSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallImageL5FormRowsDataManager.h"

@interface SmallImageL5FormRowsSlideViewController : UIViewController<SmallImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    SmallImageL5FormRowsDataManager* _smallImageL5FormRowsDataManager;
    id<SmallImageSlideViewItemDelegate> _delegate;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) SmallImageL5FormRowsDataManager* smallImageL5FormRowsDataManager;
@property(nonatomic, retain) id<SmallImageSlideViewItemDelegate> delegate;

@end
