//
//  CustomerSurveyMainSummaryTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 04/10/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"

@interface CustomerSurveyMainSummaryTableCell : CustomerSurveyBaseTableCell<UITextViewDelegate>{
//    UILabel* _narrative;
    UITextView* _responseLimits;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UITextView* responseLimits;

@end

