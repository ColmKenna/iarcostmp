//
//  CustomerContactDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 15/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerContactDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
//    NSMutableDictionary* _tableCellData;
    BOOL _isNewRecord;
    NSMutableArray* _updatedFieldNameList;
    NSMutableArray* _updatedFieldValueList;
    NSMutableArray* _dbFieldNameList;
    NSNumber* _iur;
    
//--------- contact flags-------    
    NSMutableArray* _seqFieldTypeList;
    NSMutableArray* _flagDisplayList;
    NSMutableArray* _originalFlagDisplayList;
    NSMutableArray* _flagChangedDataList;
}

@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* originalDisplayList;
//@property (nonatomic, retain) NSMutableDictionary* tableCellData;
@property (nonatomic, assign) BOOL isNewRecord;
@property(nonatomic, retain) NSMutableArray* updatedFieldNameList;
@property(nonatomic, retain) NSMutableArray* updatedFieldValueList;
@property(nonatomic, retain) NSMutableArray* dbFieldNameList;
@property(nonatomic, retain) NSNumber* iur;
//--------- contact flags-------   
@property(nonatomic, retain) NSMutableArray* seqFieldTypeList;
@property(nonatomic, retain) NSMutableArray* flagDisplayList;
@property(nonatomic, retain) NSMutableArray* originalFlagDisplayList;
@property(nonatomic, retain) NSMutableArray* flagChangedDataList;


-(void)processRawData:(ArcosGenericClass*)aContactGenericClass flagData:(NSMutableArray*)anArrayOfData;
-(NSString*)translateIUR:(NSNumber*)anIUR dataList:(NSMutableArray*)aDataList;
-(void)createCellData:(NSString*)aKeyName cellValue:(NSString*)aCellValue withIndex:(int)anIndex;
-(void)createDescrCellData:(NSString*)aKeyName descrType:(NSString*)aDescrType cellValue:(NSString*)aCellValue withIndex:(int)anIndex;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;
-(void)getChangedDataList;
- (void)createFlagBasicData;
- (void)updateChangedData:(NSNumber*)aContactFlag indexPath:(NSIndexPath*)anIndexPath;

-(void)processFlagRawData:(NSMutableArray*)anArrayOfData;
-(void)getFlagChangedDataList;


@end
