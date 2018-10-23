//
//  ReporterMainDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ArcosUtils.h"
//#import "ArcosGenericClass.h"
#import "ArcosCoreData.h"

@interface ReporterMainDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _dateDictDisplayList;
    NSMutableArray* _locationList;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* dateDictDisplayList;
@property(nonatomic, retain) NSMutableArray* locationList;

- (void)processRawData:(NSMutableArray*)aDisplayList;
- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate indexPath:(NSIndexPath*)anIndexPath;
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict indexPath:(NSIndexPath *)anIndexPath;

@end
