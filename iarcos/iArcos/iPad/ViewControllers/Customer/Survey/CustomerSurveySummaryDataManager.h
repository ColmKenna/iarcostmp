//
//  CustomerSurveySummaryDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSurveySummaryDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

//- (void)processRawData:();

@end
