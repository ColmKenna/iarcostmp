//
//  CustomerSurveyContactTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "WidgetFactory.h"

@interface CustomerSurveyContactTableCell : CustomerSurveyBaseTableCell<WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    UILabel* narrative;
    IBOutlet UILabel* contactTitle;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* contactTitle;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

-(void)handleSingleTapGesture:(id)sender;

@end
