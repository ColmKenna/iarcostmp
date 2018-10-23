//
//  CustomerSurveySlidePageTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"

@interface CustomerSurveySlidePageTableCell : CustomerSurveyBaseTableCell {
    IBOutlet UILabel* responseLimit;
}

@property(nonatomic, retain) IBOutlet UILabel* responseLimit;

@end
