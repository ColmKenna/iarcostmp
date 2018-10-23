//
//  CustomerSurveyDetailsSegmentedControlResponseTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "ArcosUtils.h"
#import "WidgetFactory.h"

@interface CustomerSurveyDetailsSegmentedControlResponseTableCell : CustomerSurveyDetailsResponseBaseTableCell <UITextFieldDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate>{
    UILabel* _narrative;
    UIView* _templateView;
    UITextField* _responseTextField;
    UILabel* _score;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UIView* templateView;
//@property(nonatomic, retain) IBOutlet UILabel* response;
@property(nonatomic, retain) IBOutlet UITextField* responseTextField;
@property(nonatomic, retain) IBOutlet UILabel* score;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

@end
