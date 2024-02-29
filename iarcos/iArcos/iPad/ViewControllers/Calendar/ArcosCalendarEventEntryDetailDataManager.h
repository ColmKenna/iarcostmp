//
//  ArcosCalendarEventEntryDetailDataManager.h
//  iArcos
//
//  Created by Richard on 12/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@interface ArcosCalendarEventEntryDetailDataManager : NSObject {
    NSString* _actionType;
    NSString* _createText;
    NSString* _headlineText;
    NSString* _dateText;
    NSString* _detailText;
    NSString* _deleteText;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSString* _subjectKey;
    NSString* _locationKey;
    NSString* _bodyKey;
    NSString* _startKey;
    NSString* _endKey;
    NSString* _allDayKey;
    
    NSMutableDictionary* _originalEventDataDict;
    NSDate* _editStartDate;
    NSDate* _editEndDate;
}

@property(nonatomic, retain) NSString* actionType;
@property(nonatomic, retain) NSString* createText;
@property(nonatomic, retain) NSString* headlineText;
@property(nonatomic, retain) NSString* dateText;
@property(nonatomic, retain) NSString* detailText;
@property(nonatomic, retain) NSString* deleteText;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic,retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic,retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic,retain) NSString* subjectKey;
@property(nonatomic,retain) NSString* locationKey;
@property(nonatomic,retain) NSString* bodyKey;
@property(nonatomic,retain) NSString* startKey;
@property(nonatomic,retain) NSString* endKey;
@property(nonatomic,retain) NSString* allDayKey;
@property(nonatomic,retain) NSMutableDictionary* originalEventDataDict;
@property(nonatomic,retain) NSDate* editStartDate;
@property(nonatomic,retain) NSDate* editEndDate;

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldDesc:(NSString*)aFieldDesc fieldName:(NSString*)aFieldName fieldData:(id)aFieldData;
- (void)retrieveCreateDataWithDate:(NSDate*)aDate title:(NSString*)aTitle location:(NSString*)aLocationStr;
- (void)retrieveEditDataWithCellData:(NSMutableDictionary*)aCellData;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)dataDetailBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (NSIndexPath*)indexPathWithFieldName:(NSString*)aFieldName;
- (void)dataRefreshListWithSwitchReturnValue:(NSString*)aReturnValue;
- (NSMutableDictionary*)retrieveEventDictWithLocationUri:(NSString*)aLocationUri;
- (NSMutableDictionary*)retrieveEditEventDictWithLocationUri:(NSString*)aLocationUri;
- (void)resetEndDateWithStartDictProcessor:(NSMutableDictionary*)aStartDict;

@end


