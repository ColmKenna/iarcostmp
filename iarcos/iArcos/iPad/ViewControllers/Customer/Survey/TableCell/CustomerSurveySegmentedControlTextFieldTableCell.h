//
//  CustomerSurveySegmentedControlTextFieldTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyBaseTableCell.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@interface CustomerSurveySegmentedControlTextFieldTableCell : CustomerSurveyBaseTableCell<UITextFieldDelegate> {
//    UILabel* _narrative;
    UISegmentedControl* _responseSegmentedControl;
    UITextField* _responseTextField;
    NSMutableArray* _segmentItemList;
}

//@property(nonatomic, retain) IBOutlet UILabel* narrative;
@property(nonatomic, retain) IBOutlet UISegmentedControl* responseSegmentedControl;
@property(nonatomic, retain) IBOutlet UITextField* responseTextField;
@property(nonatomic, retain) NSMutableArray* segmentItemList;

- (IBAction)segmentedValueChange:(id)sender;

@end
