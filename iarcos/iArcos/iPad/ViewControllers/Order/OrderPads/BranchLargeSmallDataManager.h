//
//  BranchLargeSmallDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 14/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchLeafDataProcessCenter.h"
#import "LargeImageSlideViewItemController.h"
#import "BranchLeafProductListDataManager.h"
#import "BranchLeafProductGridDataManager.h"

@interface BranchLargeSmallDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
    int _previousPage;
    int _bufferSize;
    int _halfBufferSize;
    NSString* _formType;
    NSString* _branchDescrTypeCode;
    NSString* _leafDescrTypeCode;
    NSString* _branchLxCode;
    NSString* _leafLxCode;
    NSNumber* _formTypeId;
    BranchLeafDataProcessCenter* _branchLeafDataProcessCenter;
    BranchLeafProductBaseDataManager* _branchLeafProductBaseDataManager;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) int previousPage;
@property(nonatomic, assign) int bufferSize;
@property(nonatomic, assign) int halfBufferSize;
@property(nonatomic, retain) NSString* formType;
@property(nonatomic, retain) NSString* branchDescrTypeCode;
@property(nonatomic, retain) NSString* leafDescrTypeCode;
@property(nonatomic, retain) NSString* branchLxCode;
@property(nonatomic, retain) NSString* leafLxCode;
@property(nonatomic, retain) NSNumber* formTypeId;
@property(nonatomic, retain) BranchLeafDataProcessCenter* branchLeafDataProcessCenter;
@property(nonatomic, retain) BranchLeafProductBaseDataManager* branchLeafProductBaseDataManager;

- (void)createBranchLargeSmallL45Data;
- (void)createBranchLargeSmallL35Data;
- (void)createBranchLargeSmallL45GridData;
- (void)createBranchSmallL05GridData;
- (void)analyseFormTypeRawData;
- (void)retrieveAnalyseFormTypeRawData;
- (void)getBranchLeafData;
- (void)createPlaceholderBranchLargeSmallSlideViewItemData;
- (void)fillBranchLargeSmallSlideViewItemWithIndex:(int)anIndex;


@end
