//
//  L3SearchDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "BranchLeafDataProcessCenter.h"
#import "BranchLeafProductListDataManager.h"
#import "BranchLeafProductGridDataManager.h"

@interface L3SearchDataManager : NSObject {
    NSNumber* _numberOfImages;
    NSMutableArray* _displayList;
    NSMutableArray* _descrDetailList;
    NSMutableArray* _searchedDisplayList;
    int _maxCount;
    
    NSMutableDictionary* _descrDetailSectionDict;
    NSMutableArray* _sortKeyList;
    NSString* _formType;
    NSString* _branchDescrTypeCode;
    NSString* _leafDescrTypeCode;
    NSString* _branchLxCode;
    NSString* _leafLxCode;
    NSNumber* _formTypeId;
    BranchLeafDataProcessCenter* _branchLeafDataProcessCenter;
    BranchLeafProductBaseDataManager* _branchLeafProductBaseDataManager;
}

@property(nonatomic, retain) NSNumber* numberOfImages;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* descrDetailList;
@property(nonatomic, retain) NSMutableArray* searchedDisplayList;
@property(nonatomic, assign) int maxCount;

@property(nonatomic, retain) NSMutableDictionary* descrDetailSectionDict;
@property(nonatomic, retain) NSMutableArray* sortKeyList;
@property(nonatomic, retain) NSString* formType;
@property(nonatomic, retain) NSString* branchDescrTypeCode;
@property(nonatomic, retain) NSString* leafDescrTypeCode;
@property(nonatomic, retain) NSString* branchLxCode;
@property(nonatomic, retain) NSString* leafLxCode;
@property(nonatomic, retain) NSNumber* formTypeId;
@property(nonatomic, retain) BranchLeafDataProcessCenter* branchLeafDataProcessCenter;
@property(nonatomic, retain) BranchLeafProductBaseDataManager* branchLeafProductBaseDataManager;

- (void)createL3SearchFormRowsData;
- (void)getLevel3DescrDetail;
- (void)processRawData:(NSMutableArray*)aDisplayList;
- (void)searchDescrDetailWithKeyword:(NSString*)aKeyword;
- (void)clearDescrDetailList;
- (void)getAllDescrDetailList;
- (NSMutableArray*)getL5CodeList:(NSString*)aL3Code;
- (NSArray*)getL5CodeListWithL3L5ProductList:(NSArray*)aL3L5ProductList;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;

- (void)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList;
- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList;
- (void)getBranchLeafData;
- (void)retrieveAnalyseFormTypeRawData;
- (void)createBranchBoxL45Data;
- (void)createBranchBoxL35Data;
- (void)createBranchBoxGridL35Data;
- (void)createBranchBoxGridL45Data;
@end
