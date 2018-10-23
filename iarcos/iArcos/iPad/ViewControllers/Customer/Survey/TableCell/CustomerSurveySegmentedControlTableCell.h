//
//  CustomerSurveySegmentedControlTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 30/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@interface CustomerSurveySegmentedControlTableCell : CustomerSurveyBaseTableCell {
    UILabel* _narrative;
    UISegmentedControl* _responseSegmentedControl;
    NSMutableArray* _segmentItemList;
}

@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UISegmentedControl* responseSegmentedControl;
@property(nonatomic, retain) NSMutableArray* segmentItemList;

- (IBAction)segmentedValueChange:(id)sender;

@end
