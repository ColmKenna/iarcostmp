//
//  FormRowDividerDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface FormRowDividerDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)createBasicData:(NSNumber*)aFormIUR;
- (NSMutableDictionary*)createAllNodeDict;

@end
