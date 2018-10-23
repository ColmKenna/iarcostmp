//
//  ProductSearchDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 08/11/2012.
//  Copyright (c) 	2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"
#import "FormRowSearchDelegate.h"
#import "ProductFormRowConverter.h"

@interface ProductSearchDataManager : NSObject <FormRowSearchDelegate> {
    NSMutableArray* _displayList;
    id _target;
    SEL _searchButtonClickedSelector;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL searchButtonClickedSelector;

- (id)initWithTarget:(id)aTarget;
- (void)createSearchFormDetailData;
//- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword;
- (void)createActiveProduct;
//- (void)activeProductNumber;

@end
