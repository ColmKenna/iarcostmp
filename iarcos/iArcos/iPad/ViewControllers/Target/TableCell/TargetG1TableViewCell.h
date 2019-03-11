//
//  TargetG1TableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 21/02/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTGraphHostingView.h"
#import "TargetBaseTableViewCell.h"
#import "GlobalSharedClass.h"


@interface TargetG1TableViewCell : TargetBaseTableViewCell <CPTPlotSpaceDelegate>{
    CPTGraphHostingView* _g1ChartView;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* g1ChartView;

@end


