//
//  BranchLeafDataProcessCenter.h
//  Arcos
//
//  Created by David Kilmartin on 16/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "ArcosAlgorithmUtils.h"

@interface BranchLeafDataProcessCenter : NSObject {
    ArcosAlgorithmUtils* _arcosAlgorithmUtils;    
}

@property(nonatomic, retain) ArcosAlgorithmUtils* arcosAlgorithmUtils;

- (NSMutableArray*)getBranchLeafData:(NSString*)aBranchDescrTypeCode leafDescrTypeCode:(NSString*)anLeafDescrTypeCode branchLxCode:(NSString*)aBranchLxCode leafLxCode:(NSString*)anLeafLxCode;
- (NSArray*)getLeafCodeListWithBranchLeafProductList:(NSArray*)aBranchLeafProductList leafLxCode:(NSString*)anLeafLxCode;
- (NSMutableDictionary*)analyseFormTypeRawData:(NSString*)aFormType;

@end
