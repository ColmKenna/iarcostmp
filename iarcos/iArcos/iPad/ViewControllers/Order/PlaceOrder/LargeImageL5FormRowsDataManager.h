//
//  LargeImageL5FormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 12/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LargeImageSlideViewItemController.h"
#import "ArcosCoreData.h"

@interface LargeImageL5FormRowsDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _descrDetailCode;
    int _currentPage;
    int _previousPage;
    NSMutableArray* _slideViewItemList;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* descrDetailCode;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) int previousPage;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;

- (void)createLargeImageL5SlideViewItemData;
- (void)createPlaceholderLargeImageL5SlideViewItemData;
- (void)fillLargeImageL5SlideViewItemWithIndex:(int)anIndex;

@end
