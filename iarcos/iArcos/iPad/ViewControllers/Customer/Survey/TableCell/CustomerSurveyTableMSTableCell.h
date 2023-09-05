//
//  CustomerSurveyTableMSTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "WidgetFactory.h"
#import "ArcosUtils.h"

@interface CustomerSurveyTableMSTableCell : CustomerSurveyBaseTableCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
//    UILabel* narrative;
    UILabel* responseLimits;
    WidgetFactory* factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* responseLimits;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;




@end
