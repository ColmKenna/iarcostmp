//
//  CustomerSurveyWheelTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "WidgetFactory.h"
#import "ArcosUtils.h"

@interface CustomerSurveyWheelTableCell : CustomerSurveyBaseTableCell<WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate> {
//    IBOutlet UILabel* narrative;
    IBOutlet UILabel* responseLimits;
    WidgetFactory* factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* responseLimits;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

-(void)handleSingleTapGesture:(id)sender;
//-(void)handleSingleTapGesture4Narrative:(id)sender;

@end
