//
//  CustomerSurveyDetailsResponseBooleanTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 28/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsResponseBooleanTableCell.h"

@implementation CustomerSurveyDetailsResponseBooleanTableCell
@synthesize narrative = _narrative;
@synthesize responseSegmentedControl = _responseSegmentedControl;
@synthesize auxResponse = _auxResponse;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.narrative = nil;
    self.responseSegmentedControl = nil;
    self.auxResponse = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.cellData = aCellData;
    self.narrative.text = aCellData.Field4;
    NSString* auxResponse = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:aCellData.Field6]];
    if ([[ArcosUtils convertStringToNumber:[ArcosUtils trim:aCellData.Field7]] intValue] == 0) {
        self.responseSegmentedControl.hidden = YES;
    } else {
        self.responseSegmentedControl.hidden = NO;
        if ([[auxResponse uppercaseString] isEqualToString:@"YES"]) {
            self.responseSegmentedControl.selectedSegmentIndex = 0;
        } else {
            self.responseSegmentedControl.selectedSegmentIndex = 1;
        }
    }    
}

- (IBAction)switchValueChange:(id)sender {
    UISegmentedControl* segmented = (UISegmentedControl*)sender;
    NSString* auxReturnValue = @"";
    if (segmented.selectedSegmentIndex == 0) {
        auxReturnValue = @"Yes";
    } else {
        auxReturnValue = @"No";
    }
//    auxReturnValue = [self responseActualValueWithSelectedIndex:segmented.selectedSegmentIndex];
    [self.delegate booleanInputFinishedWithData:auxReturnValue forIndexPath:self.indexPath];
}

//- (NSString*)responseActualValueWithSelectedIndex:(NSInteger)selectedIndex {
//    NSString* returnValue = @"";
//    switch (selectedIndex) {
//        case 0: {
//            returnValue = @"1";
//        }
//            break;
//        case 1: {
//            returnValue = @"0";
//        }
//            break;
//        case 2: {
//            returnValue = [GlobalSharedClass shared].unknownText;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return returnValue;
//}

@end
