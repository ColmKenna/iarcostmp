//
//  TargetYearTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetBaseTableViewCell.h"

@interface TargetYearTableViewCell : TargetBaseTableViewCell {
    CPTGraphHostingView* _barChartView;
    CPTPlotSpaceAnnotation* _yearSymbolTextAnnotation;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* barChartView;
@property(nonatomic, retain) CPTPlotSpaceAnnotation* yearSymbolTextAnnotation;

@end
