//
//  UtilitiesDescriptionDetailEditViewDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"

@interface UtilitiesDescriptionDetailEditViewDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    NSMutableDictionary* _tableCellData;
    BOOL _isNewRecord;
    NSMutableArray* _dbFieldNameList;
    NSMutableArray* _updatedFieldNameList;
    NSMutableArray* _updatedFieldValueList;
    NSMutableArray* _createFieldValueList;
}

@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* originalDisplayList;
@property (nonatomic, retain) NSMutableDictionary* tableCellData;
@property (nonatomic, assign) BOOL isNewRecord;
@property (nonatomic, retain) NSMutableArray* dbFieldNameList;
@property(nonatomic, retain) NSMutableArray* updatedFieldNameList;
@property(nonatomic, retain) NSMutableArray* updatedFieldValueList;
@property(nonatomic, retain) NSMutableArray* createFieldValueList;

-(void)processRawData:(NSMutableDictionary*)aCellData;
-(void)createTextCellValue:(NSString*)aCellValue withIndex:(int)anIndex;
-(void)createNumberCellValue:(NSNumber*)aCellValue withIndex:(int)anIndex;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;
-(void)getChangedDataList;


-(void)createTemplateWithCellValue:(id)aCellValue;
- (void)prepareForCreateProcess;


@end
