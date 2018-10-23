//
//  SmallFormDetailDividerDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 23/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmallImageSlideViewItemController.h"
#import "ArcosCoreData.h"

@interface SmallFormDetailDividerDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _slideViewItemList;
    int _currentIndexPathRow;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentIndexPathRow;

- (void)createSmallFormDetailDividerSlideViewItemData;
- (void)fillSmallFormDetailDividerSlideViewItemWithIndex:(int)anIndex;
- (void)clearSmallFormDetailDividerSlideViewItemWithIndex:(int)anIndex;

@end
