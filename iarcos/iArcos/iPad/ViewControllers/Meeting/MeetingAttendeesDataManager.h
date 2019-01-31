//
//  MeetingAttendeesDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosMeetingWithDetails.h"
#import "MeetingBaseDataManager.h"

@interface MeetingAttendeesDataManager : MeetingBaseDataManager {
    NSString* _emptyTitle;
    NSString* _employeeTitle;
    NSString* _contactTitle;
//    NSString* _otherTitle;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSIndexPath* _currentSelectedDeleteIndexPath;
    NSMutableDictionary* _currentSelectedCellData;
}

@property(nonatomic, retain) NSString* emptyTitle;
@property(nonatomic, retain) NSString* employeeTitle;
@property(nonatomic, retain) NSString* contactTitle;
//@property(nonatomic, retain) NSString* otherTitle;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSIndexPath* currentSelectedDeleteIndexPath;
@property(nonatomic, retain) NSMutableDictionary* currentSelectedCellData;

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)processAttendeesEmployeesCellDataDictList:(NSMutableArray*)aCellDataDictList;
- (void)processAttendeesContactsCellDataDictList:(NSMutableArray*)aCellDataDictList;


@end

