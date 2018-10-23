//
//  OrderInputPadDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 10/06/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface OrderInputPadDataManager : NSObject {
    NSMutableArray* _monthList;
}

@property(nonatomic, retain) NSMutableArray* monthList;

- (NSMutableArray*)retrieveLocationProductMATWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR;
- (void)processMonthListWithDate:(NSDate*)aDateLastModified;


@end
