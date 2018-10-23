//
//  SaveRecordUpdateCenterDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 02/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SaveRecordUpdateCenterDelegate <NSObject>
- (void)saveRecordUpdateCompleted:(int)aRecordCount;
- (void)updateSaveRecordProgressBar:(float)aValue;
- (void)CommitData;
- (void)batchedSaveRecordUpdateCompleted:(int)aRecordCount;

@end
