//
//  CustomerJourneyStartDateDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerJourneyStartDateDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _changedDataList;
    NSNumber* _employeeIUR;
    NSDate* _changedJourneyStartDate;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* changedDataList;
@property(nonatomic, retain) NSNumber* employeeIUR;
@property(nonatomic, retain) NSDate* changedJourneyStartDate;

- (void)createJourneyStartDateData;
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (void)getChangedDataList;

@end
