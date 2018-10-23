//
//  RemoveRecordProcessorDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 10/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface RemoveRecordProcessorDataManager : NSObject {
    BOOL _isRemovingRecordFinished;
    int _rowPointer;
    
}

@property(nonatomic, assign) BOOL isRemovingRecordFinished;
@property(nonatomic, assign) int rowPointer;

- (NSMutableArray*)retrieveAllLocationIUR;

@end
