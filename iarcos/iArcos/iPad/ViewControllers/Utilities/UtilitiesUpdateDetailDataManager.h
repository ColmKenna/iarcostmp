//
//  UtilitiesUpdateDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 03/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"
#import "ArcosCoreData.h"
#import "CompositeIndexResult.h"

@interface UtilitiesUpdateDetailDataManager : NSObject {
    NSMutableDictionary* _dataTablesDict;
    NSMutableArray* _dataTablesDisplayList;
    NSDictionary* _downloadModeConstantDict;
    NSMutableDictionary* _dataTableNameRelatedEntityDict;
    NSMutableArray* _tableNameList;
    NSString* _downloadSectionTitle;
    NSString* _uploadSectionTitle;
    NSMutableArray* _dynamicSectionTitleList;
    NSMutableArray* _sectionTitleList;
    NSMutableArray* _uploadItemsDisplayList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _groupedGenericNameDict;
    NSMutableArray* _uploadNameList;
    NSMutableDictionary* _genericNameRelatedEntityDict;
    NSMutableDictionary* _uploadItemsNameRelatedEntityDict;
    NSMutableDictionary* _sectionTitlePlistTitleRelatedDict;
    NSString* _dataTablesPlistTitle;
    NSString* _uploadItemsPlistTitle;
    NSString* _packageTableName;
}

@property(nonatomic, retain) NSMutableDictionary* dataTablesDict;
@property(nonatomic, retain) NSMutableArray* dataTablesDisplayList;
@property(nonatomic, retain) NSDictionary* downloadModeConstantDict;
@property(nonatomic, retain) NSMutableDictionary* dataTableNameRelatedEntityDict;
@property(nonatomic, retain) NSMutableArray* tableNameList;
@property(nonatomic, retain) NSString* downloadSectionTitle;
@property(nonatomic, retain) NSString* uploadSectionTitle;
@property(nonatomic, retain) NSMutableArray* dynamicSectionTitleList;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableArray* uploadItemsDisplayList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableDictionary* groupedGenericNameDict;
@property(nonatomic, retain) NSMutableArray* uploadNameList;
@property(nonatomic, retain) NSMutableDictionary* genericNameRelatedEntityDict;
@property(nonatomic, retain) NSMutableDictionary* uploadItemsNameRelatedEntityDict;
@property(nonatomic, retain) NSMutableDictionary* sectionTitlePlistTitleRelatedDict;
@property(nonatomic, retain) NSString* dataTablesPlistTitle;
@property(nonatomic, retain) NSString* uploadItemsPlistTitle;
@property(nonatomic, retain) NSString* packageTableName;

- (void)loadUpdateCenterPlist;
- (void)loadDefaultUpdateCenterPlist;
- (void)addTableRecordQty;
- (void)addTableRecordQtyWithIndex:(NSUInteger)anIndex;
- (void)configDataTableNameRelatedEntityDict;
- (void)configUploadItemsNameRelatedEntityDict;
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (NSIndexPath*)getIndexPathWithSelectorName:(NSString*)aSelectorName;
- (void)downloadFinishedWithData:(int)aDownloadRecordQty forSelectorIndexpath:(NSIndexPath*)aSelectorIndexpath;
- (void)createDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict;
- (void)createDataTablesDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict;
- (void)createUploadItemsDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict;
- (void)savePressed;
- (BOOL)isVersionDiffNotExisted;
- (void)calculateTableRecordQtyWithCompositeIndex:(CompositeIndexResult*)compositeIndexResult;
- (void)calculateTableRecordQty;
- (CompositeIndexResult*)retrieveCompositeIndexResultWithSelectorName:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle;
- (NSMutableDictionary*)retrieveDataDictWithSelectorName:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle;
- (int)retrieveSectionIndexWithSectionTitle:(NSString*)aSectionTitle;
- (void)processFinishedWithOverallNumber:(int)anOverallNumber compositeIndexResult:(CompositeIndexResult*)aCompositeIndexResult;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;

@end
