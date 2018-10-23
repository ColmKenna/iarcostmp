//
//  RemoveRecordProcessorDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 10/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RemoveRecordProcessorDelegate <NSObject>

- (void)updateRemoveRecordProgressBar:(float)aValue;
- (void)updateRemoveRecordProgressBarWithoutAnimation:(float)aValue;
- (void)updateRemoveStatusTextWithValue:(NSString*)aValue;
- (void)removeRecordProcessCompleted;
- (void)didFinishRemoveRecordUpdateCenter;

@end
