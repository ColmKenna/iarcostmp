//
//  SmallImageL5FormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmallImageSlideViewItemController.h"
#import "ArcosCoreData.h"

@interface SmallImageL5FormRowsDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _descrDetailCode;
    NSMutableArray* _slideViewItemList;
    int _currentIndexPathRow;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* descrDetailCode;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentIndexPathRow;

- (void)createSmallImageL5SlideViewItemData;
- (void)fillSmallImageL5SlideViewItemWithIndex:(int)anIndex;
- (void)clearSmallImageL5SlideViewItemWithIndex:(int)anIndex;

@end
