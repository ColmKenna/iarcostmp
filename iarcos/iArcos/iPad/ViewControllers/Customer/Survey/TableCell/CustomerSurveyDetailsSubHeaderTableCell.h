//
//  CustomerSurveyDetailsSubHeaderTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 23/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDetailsResponseBaseTableCell.h"

@interface CustomerSurveyDetailsSubHeaderTableCell : CustomerSurveyDetailsResponseBaseTableCell {
    UILabel* _narrative;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;

@end
