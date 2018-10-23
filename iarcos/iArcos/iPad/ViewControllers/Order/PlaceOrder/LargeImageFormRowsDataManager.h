//
//  LargeImageFormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 11/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "LargeImageSlideViewItemController.h"

@interface LargeImageFormRowsDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;

- (void)getLevel4DescrDetail;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;
- (void)createLargeImageSlideViewItemData;
- (void)fillLargeImageSlideViewItemWithIndex:(int)anIndex;


@end
