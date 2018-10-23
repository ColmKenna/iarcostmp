//
//  CustomerSurveyDetailsResponseTextBoxTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 29/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "ArcosUtils.h"

@interface CustomerSurveyDetailsResponseTextBoxTableCell : CustomerSurveyDetailsResponseBaseTableCell <UITextFieldDelegate>{
    UILabel* _narrative;
    UITextField* _responseTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UITextField* responseTextField;

@end
