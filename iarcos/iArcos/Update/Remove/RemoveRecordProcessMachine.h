//
//  RemoveRecordProcessMachine.h
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoveLocationProductMatProcessor.h"
#import "RemoveOrderHeaderProcessor.h"

@interface RemoveRecordProcessMachine : NSObject <RemoveRecordProcessorDelegate> {
    id<RemoveRecordProcessorDelegate> _removeDelegate;
    BOOL _isProcessingFinished;
    RemoveLocationProductMatProcessor* _removeLocationProductMatProcessor;
    RemoveOrderHeaderProcessor* _removeOrderHeaderProcessor;
}

@property(nonatomic, assign) id<RemoveRecordProcessorDelegate> removeDelegate;
@property(nonatomic, assign) BOOL isProcessingFinished;
@property(nonatomic, retain) RemoveLocationProductMatProcessor* removeLocationProductMatProcessor;
@property(nonatomic, retain) RemoveOrderHeaderProcessor* removeOrderHeaderProcessor;
 

- (void)removeLocationProductMatRecord;
- (void)removeOrderHeaderRecord;

@end
