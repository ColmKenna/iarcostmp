//
//  LeafSmallTemplateViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafSmallTemplateDataManager.h"

@interface LeafSmallTemplateViewController : UIViewController<UIScrollViewDelegate, LeafSmallTemplateViewItemDelegate> {
    UIScrollView* _myScrollView;
    LeafSmallTemplateDataManager* _leafSmallTemplateDataManager;
    id<LeafSmallTemplateViewItemDelegate> _delegate;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LeafSmallTemplateDataManager* leafSmallTemplateDataManager;
@property(nonatomic, assign) id<LeafSmallTemplateViewItemDelegate> delegate;
@property (nonatomic, assign) BOOL isNotFirstLoaded;

- (void)jumpToSpecificPage:(int)aPageIndex;
- (void)showSpecificPage:(int)aPageIndex;

@end
