//
//  CustomerPhotoSlideDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 13/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "PresenterSlideViewItemController.h"
#import "ArcosConfigDataManager.h"

@interface CustomerPhotoSlideDataManager : NSObject {
    NSMutableArray* _displayList;
    NSNumber* _locationIUR;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)createPhotoSlideBasicData;
- (void)createPhotoSlideViewItemData;
- (void)fillPhotoSlideViewItem:(PresenterSlideViewItemController*)psvic index:(int)anIndex;
- (NSString*)getFilePathWithFileName:(NSString*)aFileName;
- (BOOL)deleteCollectedRecordWithCurrentPage:(int)aCurrentPage;
- (CompositeErrorResult*)deleteCollectedFileWithCurrentPage:(int)aCurrentPage;
- (void)emptyPhotoSlideViewItemWithIndex:(int)anIndex;
- (void)updateResponseRecordWithCurrentPage:(int)aCurrentPage;

@end
