//
//  UtilitiesAnimatedDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericReturnObject.h"
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"

@interface UtilitiesAnimatedDataManager : NSObject {
    NSMutableArray* _tylyBarDisplayList;
    NSMutableArray* _tylyTableDisplayList;
    NSNumber* _maxOfTyBarAxis;
    NSNumber* _maxOfLyBarAxis;
    NSNumber* _maxOfBarAxis;
    NSDictionary* _monthMapDict;
    NSMutableArray* _tylyTableKeyList;
    NSMutableArray* _tylyTableHeadingList;
    NSString* _tyBarIdentifier;
    NSString* _lyBarIdentifier;
    NSMutableArray* _monthTableDisplayList;
    ArcosGenericClass* _monthTableFieldNames;
    NSMutableArray* _originalMonthTableDisplayList;
    ArcosGenericClass* _originalMonthTableFieldNames;
    NSMutableArray* _monthPieLegendList;
    NSMutableArray* _monthPieNullLabelDisplayList;
    NSMutableArray* _monthPieLabelDisplayList;
    NSMutableArray* _monthPieDisplayList;
    NSMutableArray* _monthPieRawDisplayList;
    NSString* _monthPieIdentifier;
    NSMutableArray* _lineDetailList;
    NSMutableArray* _lineTargetList;
    NSMutableArray* _lineActualList;
    NSNumber* _maxOfLineYAxis;
    NSDictionary* _configDict;
    NSString* _pnfDescrDetailCode;
    NSString* _pnfDetail;
//    NSMutableArray* _monthPieCompositeResultList;
    int _monthPieNormalBarCount;
    int _totalClickTime;
    int _detailClickTime;
    NSMutableArray* _monthTableRawDataDisplayList;
    NSMutableDictionary* _monthTableRawDataDisplayHashMap;
}

@property(nonatomic, retain) NSMutableArray* tylyBarDisplayList;
@property(nonatomic, retain) NSMutableArray* tylyTableDisplayList;
@property(nonatomic, retain) NSNumber* maxOfTyBarAxis;
@property(nonatomic, retain) NSNumber* maxOfLyBarAxis;
@property(nonatomic, retain) NSNumber* maxOfBarAxis;
@property(nonatomic, retain) NSDictionary* monthMapDict;
@property(nonatomic, retain) NSMutableArray* tylyTableKeyList;
@property(nonatomic, retain) NSMutableArray* tylyTableHeadingList;
@property(nonatomic, retain) NSString* tyBarIdentifier;
@property(nonatomic, retain) NSString* lyBarIdentifier;
@property(nonatomic, retain) NSMutableArray* monthTableDisplayList;
@property(nonatomic, retain) ArcosGenericClass* monthTableFieldNames;
@property(nonatomic, retain) NSMutableArray* originalMonthTableDisplayList;
@property(nonatomic, retain) ArcosGenericClass* originalMonthTableFieldNames;
@property(nonatomic, retain) NSMutableArray* monthPieLegendList;
@property(nonatomic, retain) NSMutableArray* monthPieNullLabelDisplayList;
@property(nonatomic, retain) NSMutableArray* monthPieLabelDisplayList;
@property(nonatomic, retain) NSMutableArray* monthPieDisplayList;
@property(nonatomic, retain) NSMutableArray* monthPieRawDisplayList;
@property(nonatomic, retain) NSString* monthPieIdentifier;
@property(nonatomic, retain) NSMutableArray* lineDetailList;
@property(nonatomic, retain) NSMutableArray* lineTargetList;
@property(nonatomic, retain) NSMutableArray* lineActualList;
@property(nonatomic, retain) NSNumber* maxOfLineYAxis;
@property(nonatomic, retain) NSDictionary* configDict;
@property(nonatomic, retain) NSString* pnfDescrDetailCode;
@property(nonatomic, retain) NSString* pnfDetail;
//@property(nonatomic, retain) NSMutableArray* monthPieCompositeResultList;
@property(nonatomic, assign) int monthPieNormalBarCount;
@property(nonatomic, assign) int totalClickTime;
@property(nonatomic, assign) int detailClickTime;
@property(nonatomic, retain) NSMutableArray* monthTableRawDataDisplayList;
@property(nonatomic, retain) NSMutableDictionary* monthTableRawDataDisplayHashMap;

- (void)processRawData:(ArcosGenericReturnObject*)result;
- (void)processMonthPieRawData:(ArcosGenericReturnObject*)result;
- (void)processLineRawData:(ArcosGenericReturnObject*)result;
- (NSNumber*)getMax:(NSMutableArray*)aTargetList dataList:(NSMutableArray*)anActualList;
- (void)tableDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)barDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)pieDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR levelNumber:(int)aLevelNumber;
- (int)calculateLastFourMonthsTotalWithDataDict:(NSMutableDictionary*)aDataDict;
- (int)calculateFirstNineMonthsTotalWithDataDict:(NSMutableDictionary*)aDataDict;
- (int)calculateLastThirteenMonthsTotalWithDataDict:(NSMutableDictionary*)aDataDict;
- (int)calculatePreviousTwelveMonthsTotalWithDataDict:(NSMutableDictionary*)aDataDict;

@end
