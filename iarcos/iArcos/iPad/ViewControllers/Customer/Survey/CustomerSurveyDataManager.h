//
//  CustomerSurveyDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 12/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "FileCommon.h"
#import "CustomerSurveyLoadAnswerDataManager.h"
#import "CustomerSurveyBlankSentAnswerDataManager.h"
#import "ArcosConfigDataManager.h"

@interface CustomerSurveyDataManager : NSObject {
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableArray* _displayList;
    NSMutableArray* _sectionNoList;
    
    NSMutableDictionary* _surveyDict;
    NSMutableDictionary* _contactDict;
    NSMutableArray* _sectionTitleList;
    NSNumber* _locationIUR;
    NSNumber* _masterSectionKey;
    NSMutableArray* _changedDataList;
    NSMutableArray* _originalChangedDataList;
    BOOL _isSurveySaved;
    NSIndexPath* _currentIndexPath;
    BOOL _isImagePickerDisplayed;
    CustomerSurveyInnerBaseDataManager* _innerBaseDataManager;
    NSMutableDictionary* _rankingHashMap;
    int _rankQuestionType;
}

@property(nonatomic,retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic,retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* sectionNoList;

@property(nonatomic,retain) NSMutableDictionary* surveyDict;
@property(nonatomic,retain) NSMutableDictionary* contactDict;
@property(nonatomic,retain) NSMutableArray* sectionTitleList;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) NSNumber* masterSectionKey;
@property(nonatomic,retain) NSMutableArray* changedDataList;
@property(nonatomic,retain) NSMutableArray* originalChangedDataList;
@property(nonatomic,assign) BOOL isSurveySaved;
@property(nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nonatomic,assign) BOOL isImagePickerDisplayed;
@property(nonatomic,retain) CustomerSurveyInnerBaseDataManager* innerBaseDataManager;
@property(nonatomic,retain) NSMutableDictionary* rankingHashMap;
@property(nonatomic,assign) int rankQuestionType;

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)processRawData:(NSMutableArray*)objectsArray;
-(void)updateChangedData:(id)aResponse withIndexPath:(NSIndexPath*)anIndexPath;
-(BOOL)processRawDataFromContact;
-(NSMutableArray*)getChangedDataList;
- (void)removePhotoWithIndexPath:(NSIndexPath *)anIndexPath currentFileName:(NSString *)aCurrentFileName;
- (void)removePhotoWithFileName:(NSString *)aFileName;
- (BOOL)turnOnHighlightFlagAndFindMustAnswerQuestion;

@end
