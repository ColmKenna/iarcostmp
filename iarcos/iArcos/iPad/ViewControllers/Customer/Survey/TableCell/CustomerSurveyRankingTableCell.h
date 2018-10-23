//
//  CustomerSurveyRankingTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 31/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"

@interface CustomerSurveyRankingTableCell : CustomerSurveyBaseTableCell {
    UILabel* _narrative;
    UISegmentedControl* _responseSegmentedControl;
    NSMutableArray* _segmentItemList;
    NSInteger _previousSegmentIndex;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UISegmentedControl* responseSegmentedControl;
@property(nonatomic, retain) NSMutableArray* segmentItemList;
@property(nonatomic, assign) NSInteger previousSegmentIndex;

- (IBAction)segmentedValueChange:(id)sender;


@end
