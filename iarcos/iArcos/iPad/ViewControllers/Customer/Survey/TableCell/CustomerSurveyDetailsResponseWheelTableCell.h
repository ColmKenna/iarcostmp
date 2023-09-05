//
//  CustomerSurveyDetailsResponseWheelTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 29/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "WidgetFactory.h"

@interface CustomerSurveyDetailsResponseWheelTableCell : CustomerSurveyDetailsResponseBaseTableCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate> {
    UILabel* _narrative;
    UILabel* _response;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* response;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

@end
