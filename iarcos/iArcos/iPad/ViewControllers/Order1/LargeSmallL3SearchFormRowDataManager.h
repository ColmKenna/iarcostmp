//
//  LargeSmallL3SearchFormRowDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosFormDetailBO.h"
#import "ArcosCoreData.h"
#import "LargeImageSlideViewItemController.h"

@interface LargeSmallL3SearchFormRowDataManager : NSObject {
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

- (void)createLargeSmallL3SearchFormRowsData;
- (void)getLevel3DescrDetail;
- (NSArray*)getL5CodeListWithL3L5ProductList:(NSArray*)aL3L5ProductList;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;
- (void)createLargeSmallL3SearchSlideViewItemData;
- (void)fillLargeSmallL3SearchSlideViewItemWithIndex:(int)anIndex;
- (void)createPlaceholderLargeSmallL3SearchSlideViewItemData;


@end
