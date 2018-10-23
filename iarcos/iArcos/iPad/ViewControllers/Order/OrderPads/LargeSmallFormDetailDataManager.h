//
//  LargeSmallFormDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "LargeImageSlideViewItemController.h"

@interface LargeSmallFormDetailDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
    int _previousPage;
    int _bufferSize;
    int _halfBufferSize;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) int previousPage;
@property(nonatomic, assign) int bufferSize;
@property(nonatomic, assign) int halfBufferSize;

- (void)createLargeSmallFormDetailData;
- (void)getFormDividerDetail:(NSNumber*)aFormIUR;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;
- (void)createLargeSmallFormDetailSlideViewItemData;
- (void)fillLargeSmallFormDetailSlideViewItemWithIndex:(int)anIndex;
- (void)createPlaceholderLargeSmallFormDetailSlideViewItemData;

@end
