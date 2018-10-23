//
//  UploadWebServiceDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 15/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadWebServiceDataManager : NSObject {
    NSMutableArray* _collectedDataDictList;
    NSMutableArray* _filteredCollectedDataDictList;
    int _collectedRowPointer;
}

@property(nonatomic, retain) NSMutableArray* collectedDataDictList;
@property(nonatomic, retain) NSMutableArray* filteredCollectedDataDictList;
@property(nonatomic, assign) int collectedRowPointer;

@end
