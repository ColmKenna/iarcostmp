//
//  CustomerSurveyPreviewDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 20/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSharedClass.h"
#import "PresenterSlideViewItemController.h"
#import "FileCommon.h"

@interface CustomerSurveyPreviewDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;

- (void)createPhotoSlideBasicDataWithAnswer:(NSString*)anAnswer;
- (void)createPhotoSlideViewItemData;
- (NSString*)filePathWithFileName:(NSString*)aFileName;
- (void)fillPhotoSlideViewItem:(PresenterSlideViewItemController*)psvic index:(int)anIndex;
- (void)emptyPhotoSlideViewItemWithIndex:(int)anIndex;

@end
