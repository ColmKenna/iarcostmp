//
//  SmallL5L3SearchFormRowDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmallImageSlideViewItemController.h"
#import "ArcosCoreData.h"

@interface SmallL5L3SearchFormRowDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _l3DescrDetailCode;
    NSMutableArray* _slideViewItemList;
    int _currentIndexPathRow;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* l3DescrDetailCode;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentIndexPathRow;

- (void)createSmallL5L3SearchSlideViewItemData;
- (void)fillSmallL5L3SearchSlideViewItemWithIndex:(int)anIndex;
- (void)clearSmallL5L3SearchSlideViewItemWithIndex:(int)anIndex;

@end
