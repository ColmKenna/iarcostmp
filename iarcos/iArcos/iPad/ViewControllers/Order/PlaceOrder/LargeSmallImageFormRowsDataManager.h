//
//  LargeSmallImageFormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 13/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "LargeImageSlideViewItemController.h"

@interface LargeSmallImageFormRowsDataManager : NSObject {
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

- (void)createLargeSmallImageFormRowsData;
- (void)getLevel4DescrDetail;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;
- (void)createLargeSmallImageSlideViewItemData;
- (void)fillLargeSmallImageSlideViewItemWithIndex:(int)anIndex;
- (void)createPlaceholderLargeSmallImageSlideViewItemData;

@end
