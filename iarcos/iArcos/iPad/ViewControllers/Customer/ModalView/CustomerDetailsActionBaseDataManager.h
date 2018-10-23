//
//  CustomerDetailsActionBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 03/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerDetailsActionBaseDataManager : NSObject {
    NSMutableArray* _orderedFieldTypeList;
}

@property(nonatomic, retain) NSMutableArray* orderedFieldTypeList;

- (NSMutableArray*)buyingGroupLocationListWithLocationIUR:(NSNumber*)aLocationIUR;
- (int)retrieveIURSectionIndex;

@end
