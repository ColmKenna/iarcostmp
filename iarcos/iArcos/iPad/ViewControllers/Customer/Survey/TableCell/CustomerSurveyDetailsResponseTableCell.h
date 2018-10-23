//
//  CustomerSurveyDetailsResponseTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "WidgetFactory.h"

@interface CustomerSurveyDetailsResponseTableCell : CustomerSurveyDetailsResponseBaseTableCell <UIPopoverControllerDelegate>{
    UILabel* _narrative;
    UILabel* _response;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;

}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UILabel* response;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

@end
