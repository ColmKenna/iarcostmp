//
//  CustomerSurveyDetailsResponseBooleanTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 28/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "ArcosUtils.h"

@interface CustomerSurveyDetailsResponseBooleanTableCell : CustomerSurveyDetailsResponseBaseTableCell {
    UILabel* _narrative;
    UISegmentedControl* _responseSegmentedControl;
    UILabel* _auxResponse;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UISegmentedControl* responseSegmentedControl;
@property(nonatomic, retain) IBOutlet UILabel* auxResponse;

- (IBAction)switchValueChange:(id)sender;

@end
