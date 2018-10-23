//
//  ReportMeetingDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetRecordGenericDataManager.h"

@interface ReportMeetingDataManager : NSObject {
    GetRecordGenericDataManager* _getRecordGenericDataManager;
    GetRecordGenericReturnObject* _getRecordGenericReturnObject;
    NSMutableArray* _auxOrderedFieldTypeList;
    NSMutableArray* _orderedFieldTypeList;
    int _employeeSecurityLevel;
    NSMutableArray* _changedDataList;
    NSMutableArray* _excludeFieldTypeList;
}

@property(nonatomic, retain) GetRecordGenericDataManager* getRecordGenericDataManager;
@property(nonatomic, retain) GetRecordGenericReturnObject* getRecordGenericReturnObject;
@property(nonatomic, retain) NSMutableArray* auxOrderedFieldTypeList;
@property(nonatomic, retain) NSMutableArray* orderedFieldTypeList;
@property(nonatomic, assign) int employeeSecurityLevel;
@property(nonatomic, retain) NSMutableArray* changedDataList;
@property(nonatomic, retain) NSMutableArray* excludeFieldTypeList;

- (void)retrieveOrderedFieldTypeList:(NSMutableArray*)aResultFieldTypeList;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithData:(id)aContentString actualData:(id)anActualData indexPath:(NSIndexPath*)anIndexPath;
- (void)retrieveChangedDataList;

@end
