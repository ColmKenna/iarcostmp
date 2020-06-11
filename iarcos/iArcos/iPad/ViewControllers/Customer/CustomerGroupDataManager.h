//
//  CustomerGroupDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 09/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"

@interface CustomerGroupDataManager : NSObject {
//    NSMutableArray* _contactDisplayList;
//    NSIndexPath* _contactCurrentIndexPath;
    NSMutableArray* _displayList;
    NSIndexPath* _currentIndexPath;
    NSString* _contactTypeDescrTypeCode;
    NSString* _masterLocationDescrTypeCode;
    NSString* _locationTypesDescrTypeCode;
    NSString* _accessTimesDescrTypeCode;
    NSString* _accessTimesTitle;
    NSString* _hourMinuteNoColonFormat;
    NSString* _notSeenTitle;
    NSString* _notSeenDescrTypeCode;
    int _answeredNumber;
    NSString* _notSeenDateKey;
    NSString* _locationTypesTitle;
    NSString* _wholesalerCodeTitle;
    NSString* _wholesalerCodeDescrTypeCode;
}

//@property(nonatomic, retain) NSMutableArray* contactDisplayList;
//@property(nonatomic, retain) NSIndexPath* contactCurrentIndexPath;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) NSString* contactTypeDescrTypeCode;
@property(nonatomic, retain) NSString* masterLocationDescrTypeCode;
@property(nonatomic, retain) NSString* locationTypesDescrTypeCode;
@property(nonatomic, retain) NSString* accessTimesDescrTypeCode;
@property(nonatomic, retain) NSString* accessTimesTitle;
@property(nonatomic, retain) NSString* hourMinuteNoColonFormat;
@property(nonatomic, retain) NSString* notSeenTitle;
@property(nonatomic, retain) NSString* notSeenDescrTypeCode;
@property(nonatomic, assign) int answeredNumber;
@property(nonatomic, retain) NSString* notSeenDateKey;
@property(nonatomic, retain) NSString* locationTypesTitle;
@property(nonatomic, retain) NSString* wholesalerCodeTitle;
@property(nonatomic, retain) NSString* wholesalerCodeDescrTypeCode;

//- (void)createContactDataList;
- (void)inputFinishedWithData:(id)aData indexPath:(NSIndexPath*)anIndexPath;
//- (void)resetContactDataList;
//- (NSMutableArray*)retrieveContactApplyPredicateList;
- (NSMutableArray*)applyButtonPressed;
- (void)sortContactLocationResultList:(NSMutableArray*)aResultList;
- (void)createDataList;
- (void)resetDataList;
- (NSMutableDictionary*)createInitialAnswer;
- (NSMutableDictionary*)createAccessTimesDict;
- (NSMutableDictionary*)processAccessTimesResult:(NSMutableDictionary *)aWeekDayDict startTime:(NSDate *)aStartTime endTime:(NSDate *)anEndTime;
- (NSPredicate*)retrieveAccessTimesPredicateWithDict:(NSMutableDictionary *)anAccessTimeAnswerDict;
- (NSMutableDictionary*)createNotSeenDict;
- (NSMutableDictionary*)processNotSeenResult:(id)aData;
- (NSMutableDictionary*)retrieveCellDataWithDescrTypeCode:(NSString*)aDescrTypeCode;
- (NSMutableArray*)filterWithNotSeenCondition:(NSMutableDictionary*)aNotSeenDataDict resultList:(NSMutableArray*)aResultList fieldName:(NSString*)aFieldName;
- (NSMutableDictionary*)processBuyingGroupResult:(NSMutableDictionary*)aResultDict;
- (NSMutableDictionary*)createLocationTypesDict;
- (NSMutableDictionary*)createWholesalerCodeDict;
- (NSMutableDictionary*)processWholesalerCodeResult:(NSString*)aData;
- (void)filterWithWholesalerCodeCondition:(NSMutableDictionary*)aWholesalerCodeDict resultList:(NSMutableArray*)aResultList;

@end
