//
//  ThousandsLabelProvider.h
//  SciChartText
//
//  Created by David Kilmartin on 23/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <SciChart/SciChart.h>SCINumericLabelProvider

@interface ThousandsLabelProvider : NSObject {
    NSMutableDictionary* _dataHashmap;
}

@property(nonatomic, retain) NSMutableDictionary* dataHashmap;

@end
