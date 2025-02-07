//
//  UtilitiesUpdateDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 03/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesUpdateDetailDataManager.h"

@implementation UtilitiesUpdateDetailDataManager

@synthesize dataTablesDict = _dataTablesDict;
@synthesize dataTablesDisplayList = _dataTablesDisplayList;
@synthesize dataTablesIndexHashMap = _dataTablesIndexHashMap;
@synthesize downloadModeConstantDict = _downloadModeConstantDict;
@synthesize dataTableNameRelatedEntityDict = _dataTableNameRelatedEntityDict;
@synthesize tableNameList = _tableNameList;
@synthesize downloadSectionTitle = _downloadSectionTitle;
@synthesize uploadSectionTitle = _uploadSectionTitle;
@synthesize dynamicSectionTitleList = _dynamicSectionTitleList;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize uploadItemsDisplayList = _uploadItemsDisplayList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize groupedGenericNameDict = _groupedGenericNameDict;
@synthesize uploadNameList = _uploadNameList;
@synthesize genericNameRelatedEntityDict = _genericNameRelatedEntityDict;
@synthesize uploadItemsNameRelatedEntityDict = _uploadItemsNameRelatedEntityDict;
@synthesize sectionTitlePlistTitleRelatedDict = _sectionTitlePlistTitleRelatedDict;
@synthesize dataTablesPlistTitle = _dataTablesPlistTitle;
@synthesize uploadItemsPlistTitle = _uploadItemsPlistTitle;
@synthesize packageTableName = _packageTableName;
/*
 0: FULL
 1: PARTIAL
 2: EXCLUDE
*/ 

-(id)init{
    self=[super init];
    if (self!=nil) {
        self.packageTableName = @"Package";
        self.downloadModeConstantDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"FULL",@"PARTIAL",@"EXCLUDE", nil] forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
        self.downloadSectionTitle = @"Download V2";
        self.uploadSectionTitle = @"Upload";
        self.dataTablesPlistTitle = @"DataTables";
        self.uploadItemsPlistTitle = @"UploadItems";
        self.sectionTitlePlistTitleRelatedDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [self.sectionTitlePlistTitleRelatedDict setObject:self.dataTablesPlistTitle forKey:self.downloadSectionTitle];
        [self.sectionTitlePlistTitleRelatedDict setObject:self.uploadItemsPlistTitle forKey:self.uploadSectionTitle];
        self.dynamicSectionTitleList = [NSMutableArray arrayWithObjects:self.downloadSectionTitle, self.uploadSectionTitle, nil];
        self.sectionTitleList = [NSMutableArray arrayWithArray:self.dynamicSectionTitleList];
        [self.sectionTitleList addObject:@"Update Status"];
//        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.downloadSectionTitle, self.uploadSectionTitle, @"Update Status", nil];
        if (![FileCommon updateCenterPlistExist]) {
            [self loadDefaultUpdateCenterPlist];
        } else {
            if ([self isVersionDiffNotExisted]) {
                [self loadUpdateCenterPlist];
            } else {
                [self loadDefaultUpdateCenterPlist];
            }
        }
        [self addTableRecordQty];
        [self calculateTableRecordQty];
    }
    
    return self;
}

- (void)dealloc {
    if (self.dataTablesDict != nil) { self.dataTablesDict = nil; }
    if (self.dataTablesDisplayList != nil) { self.dataTablesDisplayList = nil; }
    self.dataTablesIndexHashMap = nil;
    if (self.downloadModeConstantDict != nil) { self.downloadModeConstantDict = nil; }
    if (self.dataTableNameRelatedEntityDict != nil) { self.dataTableNameRelatedEntityDict = nil; }
    if (self.tableNameList != nil) { self.tableNameList = nil; }
    self.downloadSectionTitle = nil;
    self.uploadSectionTitle = nil;
    self.dynamicSectionTitleList = nil;
    self.sectionTitleList = nil;
    self.uploadItemsDisplayList = nil;
    self.groupedDataDict = nil;
    self.groupedGenericNameDict = nil;
    self.uploadNameList = nil;
    self.genericNameRelatedEntityDict = nil;
    self.uploadItemsNameRelatedEntityDict = nil;
    self.sectionTitlePlistTitleRelatedDict = nil;
    self.dataTablesPlistTitle = nil;
    self.uploadItemsPlistTitle = nil;
    self.packageTableName = nil;
    
    [super dealloc];
}

- (void)configDataTableNameRelatedEntityDict {
//    self.tableNameList = [NSMutableArray arrayWithCapacity:[aDataTablesDisplayList count]];
//    for (int i = 0; i < [aDataTablesDisplayList count]; i++) {
//        NSMutableDictionary* dataDict = [aDataTablesDisplayList objectAtIndex:i];
//        NSString* tableName = [dataDict objectForKey:@"TableName"];
//        [self.tableNameList addObject:tableName];
//    }
    @try {
        //should be synced when there is a new table added.
        self.dataTableNameRelatedEntityDict = [NSMutableDictionary dictionaryWithCapacity:[self.tableNameList count]];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].packageSelectorName, nil] forKey:self.packageTableName];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].locationSelectorName, [GlobalSharedClass shared].locLocLinkSelectorName, nil] forKey:@"Location"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].locationProductMATSelectorName, nil] forKey:@"Location MAT"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].productSelectorName] forKey:@"Product"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].priceSelectorName] forKey:@"Price"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].descrDetailSelectorName, [GlobalSharedClass shared].descrTypeSelectorName, nil] forKey:@"Description"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].presenterSelectorName] forKey:@"Presenter"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].imageSelectorName] forKey:@"Image"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].contactSelectorName, [GlobalSharedClass shared].conLocLinkSelectorName, nil] forKey:@"Contact"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObjects:[GlobalSharedClass shared].formDetailSelectorName, [GlobalSharedClass shared].formRowSelectorName, nil] forKey:@"Form"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].employeeSelectorName] forKey:@"Employee"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].configSelectorName] forKey:@"Configuration"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].orderHeaderSelectorName] forKey:@"Order"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].callOrderHeaderSelectorName] forKey:@"Call"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].surveySelectorName] forKey:@"Survey"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].journeySelectorName] forKey:@"Journey"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].resourcesSelectorName] forKey:@"Resources"];
        [self.dataTableNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].responseSelectorName] forKey:@"Response"];
        [self.genericNameRelatedEntityDict setObject:self.dataTableNameRelatedEntityDict forKey:self.downloadSectionTitle];
//        NSLog(@"self.tableNameList: %@", self.tableNameList);
//        NSLog(@"self.dataTableNameRelatedEntityDict is:%@", self.dataTableNameRelatedEntityDict);        
    }
    @catch (NSException *exception) {
//        [ArcosUtils showMsg:[exception reason] delegate:nil];
        [ArcosUtils showDialogBox:[exception reason] title:@"" target:[ArcosUtils getRootView] handler:nil];
    }    
}

- (void)configUploadItemsNameRelatedEntityDict {
    self.uploadItemsNameRelatedEntityDict = [NSMutableDictionary dictionaryWithCapacity:[self.uploadNameList count]];
    [self.uploadItemsNameRelatedEntityDict setObject:[NSArray arrayWithObject:[GlobalSharedClass shared].collectedSelectorName] forKey:@"Photo"];
    [self.genericNameRelatedEntityDict setObject:self.uploadItemsNameRelatedEntityDict forKey:self.uploadSectionTitle];
}

- (void)loadUpdateCenterPlist {
    self.dataTablesDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon updateCenterPlistPath]];
    [self createDisplayListFromPlist:self.dataTablesDict];
}

- (void)loadDefaultUpdateCenterPlist {
    NSString* updateCenterPlistPath = [[NSBundle mainBundle] pathForResource:@"UpdateCenter" ofType:@"plist"];
    self.dataTablesDict = [NSMutableDictionary dictionaryWithContentsOfFile: updateCenterPlistPath];
    [self.dataTablesDict writeToFile:[FileCommon updateCenterPlistPath] atomically:YES];
    [self createDisplayListFromPlist:self.dataTablesDict];
}

- (void)createDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict {
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    self.groupedGenericNameDict = [NSMutableDictionary dictionaryWithCapacity:2];
    self.genericNameRelatedEntityDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [self createDataTablesDisplayListFromPlist:aDataTablesDict];
    [self createUploadItemsDisplayListFromPlist:aDataTablesDict];
}

- (void)createDataTablesDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict {
    NSMutableArray* tmpDisplayList = [aDataTablesDict objectForKey:@"DataTables"];
    self.dataTablesDisplayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    self.tableNameList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    self.dataTablesIndexHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpDisplayList count]];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* tmpDataDict = [tmpDisplayList objectAtIndex:i];
        [self.dataTablesIndexHashMap setObject:[NSNumber numberWithInt:i] forKey:[tmpDataDict objectForKey:@"IUR"]];
        NSMutableDictionary* newDataDict = [NSMutableDictionary dictionaryWithDictionary:tmpDataDict];
        NSString* auxTableName = [newDataDict objectForKey:@"TableName"];
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag] && [auxTableName isEqualToString:self.packageTableName]) {
            continue;
        }
        [self.tableNameList addObject:auxTableName];
        [self.dataTablesDisplayList addObject:newDataDict];
    }
    [self.groupedGenericNameDict setObject:self.tableNameList forKey:self.downloadSectionTitle];
    [self.groupedDataDict setObject:self.dataTablesDisplayList forKey:self.downloadSectionTitle];
    [self configDataTableNameRelatedEntityDict];
}

- (void)createUploadItemsDisplayListFromPlist:(NSMutableDictionary*)aDataTablesDict {
    NSMutableArray* tmpDisplayList = [aDataTablesDict objectForKey:@"UploadItems"];
    self.uploadItemsDisplayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    self.uploadNameList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* newDataDict = [NSMutableDictionary dictionaryWithDictionary:[tmpDisplayList objectAtIndex:i]];
        [self.uploadNameList addObject:[newDataDict objectForKey:@"TableName"]];
        [self.uploadItemsDisplayList addObject:newDataDict];
    }
    [self.groupedGenericNameDict setObject:self.uploadNameList forKey:self.uploadSectionTitle];
    [self.groupedDataDict setObject:self.uploadItemsDisplayList forKey:self.uploadSectionTitle];
    [self configUploadItemsNameRelatedEntityDict];
}

- (void)addTableRecordQty {
    for (int i = 0; i < [self.tableNameList count]; i++) {
        [self addTableRecordQtyWithIndex:i];
    }
}

- (void)addTableRecordQtyWithIndex:(NSUInteger)anIndex {
    NSString* tableName = [self.tableNameList objectAtIndex:anIndex];
    NSArray* tmpEntityNameList = [self.dataTableNameRelatedEntityDict objectForKey:tableName];
    int totalRecordQty = 0;
    for (int j = 0; j < [tmpEntityNameList count]; j++) {
        NSNumber* recordQty = nil;
        NSString* entityName = [tmpEntityNameList objectAtIndex:j];
        if ([entityName isEqualToString:[GlobalSharedClass shared].orderHeaderSelectorName]) {
            NSPredicate* orderPredicate = [NSPredicate predicateWithFormat:@"NumberOflines > 0"];
            recordQty = [[ArcosCoreData sharedArcosCoreData] recordQtyWithEntityName:@"OrderHeader" predicate:orderPredicate];
        } else if ([entityName isEqualToString:[GlobalSharedClass shared].callOrderHeaderSelectorName]) {
            NSPredicate* callPredicate = [NSPredicate predicateWithFormat:@"NumberOflines = 0"];
            recordQty = [[ArcosCoreData sharedArcosCoreData] recordQtyWithEntityName:@"OrderHeader" predicate:callPredicate];
        } else if([entityName isEqualToString:[GlobalSharedClass shared].resourcesSelectorName]) {
            recordQty = [NSNumber numberWithUnsignedInteger:[FileCommon fileCountUnderFolder:@"presenter"]];
        } else {
            recordQty = [[ArcosCoreData sharedArcosCoreData] entityRecordQuantity:entityName];
        }
        totalRecordQty += [recordQty intValue];
    }
    NSMutableDictionary* dataDict = [self.dataTablesDisplayList objectAtIndex:anIndex];
    [dataDict setObject:[NSNumber numberWithInt:totalRecordQty] forKey:@"TableRecordQty"];
}

- (void)calculateTableRecordQtyWithCompositeIndex:(CompositeIndexResult*)compositeIndexResult {
    NSMutableArray* auxNameList = [self.groupedGenericNameDict objectForKey:compositeIndexResult.sectionTitle];
    NSMutableDictionary* auxNameRelatedEntityDict = [self.genericNameRelatedEntityDict objectForKey:compositeIndexResult.sectionTitle];
    NSString* auxName = [auxNameList objectAtIndex:compositeIndexResult.indexPath.section];
    NSArray* auxEntityNameList = [auxNameRelatedEntityDict objectForKey:auxName];
    int auxTotalRecordQty = 0;
    for (int j = 0; j < [auxEntityNameList count]; j++) {
        NSNumber* auxRecordQty = nil;
        NSString* auxEntityName = [auxEntityNameList objectAtIndex:j];
        auxRecordQty = [[ArcosCoreData sharedArcosCoreData] entityRecordQuantity:auxEntityName];
        auxTotalRecordQty += [auxRecordQty intValue];
    }
    NSMutableArray* auxDisplayList = [self.groupedDataDict objectForKey:compositeIndexResult.sectionTitle];
    NSMutableDictionary* auxDataDict = [auxDisplayList objectAtIndex:compositeIndexResult.indexPath.section];
    [auxDataDict setObject:[NSNumber numberWithInt:auxTotalRecordQty] forKey:@"TableRecordQty"];
}

- (void)calculateTableRecordQty {
    NSMutableArray* myNameList = [self.groupedGenericNameDict objectForKey:self.uploadSectionTitle];
    for (int i = 0; i < [myNameList count]; i++) {
        CompositeIndexResult* myCompositeIndexResult = [[[CompositeIndexResult alloc] init] autorelease];
        NSIndexPath* myIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        myCompositeIndexResult.sectionTitle = self.uploadSectionTitle;
        myCompositeIndexResult.indexPath = myIndexPath;
        [self calculateTableRecordQtyWithCompositeIndex:myCompositeIndexResult];
    }
}

- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:theIndexpath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    NSMutableDictionary* dataDict = [tmpDisplayList objectAtIndex:theIndexpath.row];
    [dataDict setObject:[data objectForKey:@"DownloadMode"] forKey:@"DownloadMode"];
    [dataDict setObject:[data objectForKey:@"Title"] forKey:@"DownloadModeName"];
}

- (NSIndexPath*)getIndexPathWithSelectorName:(NSString*)aSelectorName {
    BOOL isFound = NO;
    int i = 0;
    int j = 0;
    for (i = 0; i < [self.tableNameList count]; i++) {
        NSString* tableName = [self.tableNameList objectAtIndex:i];
        NSArray* selectorNameList = [self.dataTableNameRelatedEntityDict objectForKey:tableName];
        for (j = 0; j < [selectorNameList count]; j++) {
            if ([aSelectorName isEqualToString:[selectorNameList objectAtIndex:j]]) {
                isFound = YES;
                break;
            }
        }
        if (isFound) {
            break;
        }
    }
//    NSLog(@"isFound %d", isFound);
    if (!isFound) {
        return nil;
    }
//    NSLog(@"second isFound %d", isFound);
    return [NSIndexPath indexPathForRow:j inSection:i];
}

- (CompositeIndexResult*)retrieveCompositeIndexResultWithSelectorName:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle {
    NSMutableArray* myNameList = [self.groupedGenericNameDict objectForKey:aSectionTitle];
    NSMutableDictionary* auxNameRelatedEntityDict = [self.genericNameRelatedEntityDict objectForKey:aSectionTitle];
    CompositeIndexResult* compositeIndexResult = [[[CompositeIndexResult alloc] init] autorelease];
    compositeIndexResult.sectionTitle = aSectionTitle;
    BOOL isFound = NO;
    int i = 0;
    int j = 0;
    for (i = 0; i < [myNameList count]; i++) {
        NSString* myName = [myNameList objectAtIndex:i];
        NSArray* selectorNameList = [auxNameRelatedEntityDict objectForKey:myName];
        for (j = 0; j < [selectorNameList count]; j++) {
            if ([aSelectorName isEqualToString:[selectorNameList objectAtIndex:j]]) {
                isFound = YES;
                break;
            }
        }
        if (isFound) {
            break;
        }
    }
    if (isFound) {
        compositeIndexResult.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
    }
    return compositeIndexResult;
}

- (NSMutableDictionary*)retrieveDataDictWithSelectorName:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle {
    CompositeIndexResult* tmpCompositeIndexResult = [self retrieveCompositeIndexResultWithSelectorName:aSelectorName sectionTitle:aSectionTitle];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:aSectionTitle];
    return [tmpDisplayList objectAtIndex:tmpCompositeIndexResult.indexPath.section];
}

- (void)downloadFinishedWithData:(int)aDownloadRecordQty forSelectorIndexpath:(NSIndexPath*)aSelectorIndexpath {
    NSInteger selectorRow = aSelectorIndexpath.row;
    NSMutableDictionary* dataDict = [self.dataTablesDisplayList objectAtIndex:aSelectorIndexpath.section];
    NSNumber* downloadRecordQty = [dataDict objectForKey:@"DownloadRecordQty"];
//    NSLog(@"DownloadRecordQty: %d", [downloadRecordQty intValue]);
    [dataDict setObject:[NSNumber numberWithInt:aDownloadRecordQty + [downloadRecordQty intValue]] forKey:@"DownloadRecordQty"];
    [self addTableRecordQtyWithIndex:aSelectorIndexpath.section];
    if (selectorRow == 0) {
        [dataDict setObject:[NSDate date] forKey:@"DownloadDate"];
        [dataDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDownloaded"];
        NSMutableArray* plistDisplayList = [self.dataTablesDict objectForKey:@"DataTables"];
        NSNumber* plistIndex = [self.dataTablesIndexHashMap objectForKey:[dataDict objectForKey:@"IUR"]];
        NSMutableDictionary* plistDataDict = [plistDisplayList objectAtIndex:[plistIndex intValue]];
        [plistDataDict setObject:[NSDate date] forKey:@"DownloadDate"];
        [plistDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDownloaded"];
        [self.dataTablesDict writeToFile:[FileCommon updateCenterPlistPath] atomically:YES];
    }    
}

- (void)savePressed {
    NSMutableArray* plistDisplayList = [self.dataTablesDict objectForKey:@"DataTables"];
    for (int i = 0; i < [self.dataTablesDisplayList count]; i++) {
        NSMutableDictionary* dataDict = [self.dataTablesDisplayList objectAtIndex:i];
        NSNumber* plistIndex = [self.dataTablesIndexHashMap objectForKey:[dataDict objectForKey:@"IUR"]];
        NSMutableDictionary* plistDataDict = [plistDisplayList objectAtIndex:[plistIndex intValue]];
        NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
        NSString* downloadModeName = [dataDict objectForKey:@"DownloadModeName"];
        NSNumber* newDownloadMode = [NSNumber numberWithInt:[downloadMode intValue]];
        NSString* newDownloadModeName = [NSString stringWithString:downloadModeName];
        [plistDataDict setObject:newDownloadMode forKey:@"DownloadMode"];
        [plistDataDict setObject:newDownloadModeName forKey:@"DownloadModeName"];     
    }
    NSMutableArray* uploadItemsList = [self.dataTablesDict objectForKey:@"UploadItems"];
    for (int j = 0; j < [self.uploadItemsDisplayList count]; j++) {
        NSMutableDictionary* dataDict = [self.uploadItemsDisplayList objectAtIndex:j];
        NSMutableDictionary* uploadItemsDataDict = [uploadItemsList objectAtIndex:j];
        NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
        NSString* downloadModeName = [dataDict objectForKey:@"DownloadModeName"];
        NSNumber* newDownloadMode = [NSNumber numberWithInt:[downloadMode intValue]];
        NSString* newDownloadModeName = [NSString stringWithString:downloadModeName];
        [uploadItemsDataDict setObject:newDownloadMode forKey:@"DownloadMode"];
        [uploadItemsDataDict setObject:newDownloadModeName forKey:@"DownloadModeName"];
    }
    [self.dataTablesDict writeToFile:[FileCommon updateCenterPlistPath] atomically:YES];
}

- (BOOL)isVersionDiffNotExisted {
    NSString* updateCenterPlistPath = [[NSBundle mainBundle] pathForResource:@"UpdateCenter" ofType:@"plist"];
    NSMutableDictionary* defaultUpdateCenterPlist = [NSMutableDictionary dictionaryWithContentsOfFile: updateCenterPlistPath];
    NSMutableDictionary* documentUpdateCenterPlist = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon updateCenterPlistPath]];
    NSString* documentVersion = [documentUpdateCenterPlist objectForKey:@"Version"];
    NSString* defaultVersion = [defaultUpdateCenterPlist objectForKey:@"Version"];
    if ([documentVersion isEqualToString:defaultVersion]) {
        return YES;
    }
    return NO;
}

- (int)retrieveSectionIndexWithSectionTitle:(NSString*)aSectionTitle {
    int resultIndex = 0;
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        if ([aSectionTitle isEqualToString:[self.sectionTitleList objectAtIndex:i]]) {
            resultIndex = i;
            break;
        }
    }
    return resultIndex;
}

- (void)processFinishedWithOverallNumber:(int)anOverallNumber compositeIndexResult:(CompositeIndexResult*)aCompositeIndexResult {
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:aCompositeIndexResult.sectionTitle];
    NSInteger selectorRow = aCompositeIndexResult.indexPath.row;
    NSMutableDictionary* dataDict = [tmpDisplayList objectAtIndex:aCompositeIndexResult.indexPath.section];
    NSNumber* downloadRecordQty = [dataDict objectForKey:@"DownloadRecordQty"];
    //    NSLog(@"DownloadRecordQty: %d", [downloadRecordQty intValue]);
    [dataDict setObject:[NSNumber numberWithInt:anOverallNumber + [downloadRecordQty intValue]] forKey:@"DownloadRecordQty"];
    [self calculateTableRecordQtyWithCompositeIndex:aCompositeIndexResult];
//    [self addTableRecordQtyWithIndex:aSelectorIndexpath.section];
    if (selectorRow == 0) {
        [dataDict setObject:[NSDate date] forKey:@"DownloadDate"];
        [dataDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDownloaded"];
        NSString* tmpKey = [self.sectionTitlePlistTitleRelatedDict objectForKey:aCompositeIndexResult.sectionTitle];
        NSMutableArray* plistDisplayList = [self.dataTablesDict objectForKey:tmpKey];
        NSMutableDictionary* plistDataDict = [plistDisplayList objectAtIndex:aCompositeIndexResult.indexPath.section];
        [plistDataDict setObject:[NSDate date] forKey:@"DownloadDate"];
        [plistDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDownloaded"];
        [self.dataTablesDict writeToFile:[FileCommon updateCenterPlistPath] atomically:YES];
    }
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* mySectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:mySectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

@end
