//
//  LeafSmallTemplateDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 19/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafSmallTemplateViewItemController.h"
#import "BranchLeafMiscUtils.h"

@interface LeafSmallTemplateDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _branchDetail;
    NSString* _branchDescrDetailCode;
    NSMutableArray* _slideViewItemList;
    int _currentPage;
    int _itemPerPage;
    int _previousPage;
    int _bufferSize;
    int _halfBufferSize;
    NSMutableArray* _pagedDisplayList;
    BranchLeafMiscUtils* _branchLeafMiscUtils;
    
    NSMutableArray* _pageIndexList;
    NSMutableDictionary* _pageIndexDict;
    
    NSString* _branchLxCode;
    NSString* _leafLxCode;
    NSIndexPath* _selectedIndexPath;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* branchDetail;
@property(nonatomic, retain) NSString* branchDescrDetailCode;
@property(nonatomic, retain) NSMutableArray* slideViewItemList;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) int itemPerPage;
@property(nonatomic, assign) int previousPage;
@property(nonatomic, assign) int bufferSize;
@property(nonatomic, assign) int halfBufferSize;
@property(nonatomic, retain) NSMutableArray* pagedDisplayList;
@property(nonatomic, retain) BranchLeafMiscUtils* branchLeafMiscUtils;
@property(nonatomic, retain) NSMutableArray* pageIndexList;
@property(nonatomic, retain) NSMutableDictionary* pageIndexDict;
@property(nonatomic, retain) NSString* branchLxCode;
@property(nonatomic, retain) NSString* leafLxCode;
@property(nonatomic, retain) NSIndexPath* selectedIndexPath;

- (void)createLeafSmallTemplateViewItemData;
- (void)fillLeafSmallTemplateViewItemWithIndex:(int)anIndex;
- (void)createPlaceholderLeafSmallTemplateViewItemData;
- (void)createPageIndexList:(int)aFormTypeNumber;


@end
