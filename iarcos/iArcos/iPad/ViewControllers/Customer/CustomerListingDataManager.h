//
//  CustomerListingDataManager.h
//  iArcos
//
//  Created by Richard on 09/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerListingDataManager : NSObject {
    BOOL _popoverOpenFlag;
    BOOL _useCallTableCellFlag;
    NSMutableDictionary* _callHeaderHashMap;
    float _textViewContentWidth;
    NSMutableDictionary* _memoTextViewHeightHashMap;
}

@property(nonatomic, assign) BOOL popoverOpenFlag;
@property(nonatomic, assign) BOOL useCallTableCellFlag;
@property(nonatomic, retain) NSMutableDictionary* callHeaderHashMap;
@property(nonatomic, assign) float textViewContentWidth;
@property(nonatomic, retain) NSMutableDictionary* memoTextViewHeightHashMap;

- (void)callHeaderProcessorWithDataList:(NSMutableArray*)aDataList;
- (void)memoTextViewHeightProcessor;

@end

