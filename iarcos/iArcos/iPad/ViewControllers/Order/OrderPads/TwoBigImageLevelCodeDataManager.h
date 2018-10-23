//
//  TwoBigImageLevelCodeDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchLeafDataProcessCenter.h"

@interface TwoBigImageLevelCodeDataManager : NSObject {
    NSNumber* _numberOfImages;
    NSMutableArray* _displayList;
    NSMutableArray* _descrDetailList;
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
    NSMutableArray* _myDescrDetailArrayList;
}

@property(nonatomic, retain) NSNumber* numberOfImages;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* descrDetailList;
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
@property(nonatomic, retain) NSMutableArray* myDescrDetailArrayList;

- (void)getBranchLeafData;
- (void)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList;
- (void)retrieveAnalyseFormTypeRawData;
- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList;
- (void)createTwoBigBoxGridL45Data;
- (void)processDescrDetailArrayList:(NSMutableArray*)aDisplayList;

@end
