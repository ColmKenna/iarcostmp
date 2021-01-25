//
//  ReporterXmlGraphViewController.h
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReporterXmlGraphDataManager.h"
#import "CorePlot-CocoaTouch.h"
#import "GlobalSharedClass.h"

@interface ReporterXmlGraphViewController : UIViewController <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTBarPlotDelegate>{
    ReporterXmlGraphDataManager* _reporterXmlGraphDataManager;
    CPTGraphHostingView* _chartView;
}

@property(nonatomic, retain) ReporterXmlGraphDataManager* reporterXmlGraphDataManager;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* chartView;


@end

