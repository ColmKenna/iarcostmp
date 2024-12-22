//
//  PresenterMainDataManager.h
//  iArcos
//
//  Created by Richard on 10/12/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface PresenterMainDataManager : NSObject {
    NSNumber* _mainPresenterIUR;
    BOOL _emailAllAtCombinedPresenterFlag;
    NSNumber* _presenterIURForFlag;
    NSMutableArray* _flagChangedDataList;
}

@property(nonatomic, retain) NSNumber* mainPresenterIUR;
@property(nonatomic, assign) BOOL emailAllAtCombinedPresenterFlag;
@property(nonatomic, retain) NSNumber* presenterIURForFlag;
@property(nonatomic, retain) NSMutableArray* flagChangedDataList;

- (NSMutableArray*)retrieveDescrDetailForFlagWithPresenterIUR:(NSNumber*)aPresenterIUR;
- (void)retrieveFlagChangedDataListWithDescrDetailDictList:(NSMutableArray*)aDescrDetailDictList;

@end

