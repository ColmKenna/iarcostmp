//
//  BranchLeafProductDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface BranchLeafProductDataManager : NSObject {
    int _itemPerRow;
    NSMutableArray* _displayList;
    NSMutableArray* _descrDetailList;
    NSIndexPath* _selectedIndexPath;
    NSMutableDictionary* _funcBtnProductSpecHashMap;
    
    NSMutableDictionary* _productSectionDict;
    NSMutableArray* _sortKeyList;
    NSString* _formType;
    int _formTypeNumber;
    NSNumber* _formIUR;
    NSMutableArray* _leafChildrenList;
}

@property(nonatomic, assign) int itemPerRow;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* descrDetailList;
@property(nonatomic, retain) NSIndexPath* selectedIndexPath;
@property(nonatomic, retain) NSMutableDictionary* funcBtnProductSpecHashMap;

@property(nonatomic, retain) NSMutableDictionary* productSectionDict;
@property(nonatomic, retain) NSMutableArray* sortKeyList;
@property(nonatomic, retain) NSString* formType;
@property(nonatomic, assign) int formTypeNumber;
@property(nonatomic, retain) NSNumber* formIUR;
@property(nonatomic, retain) NSMutableArray* leafChildrenList;

- (void)processRawData:(NSMutableArray*)aDisplayList;
- (void)processRawData4DisplayList;
- (void)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList formTypeNumber:(int)aFormTypeNumber;
- (void)getFormDividerWithFormIUR:(NSNumber*)aFormIUR;
- (void)fillTheUnsortListWithData:(NSMutableArray*)anUnsortedList;
- (NSMutableDictionary*)analyseLeafFormTypeRawData:(NSString*)aFormType;
- (void)retrieveLeafNodesWithLeafDescrTypeCode:(NSString*)anLeafDescrTypeCode leafLxCode:(NSString*)anLeafLxCode;

@end
