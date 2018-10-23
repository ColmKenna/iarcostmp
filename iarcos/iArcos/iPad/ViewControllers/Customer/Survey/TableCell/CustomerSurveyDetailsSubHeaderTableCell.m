//
//  CustomerSurveyDetailsSubHeaderTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 23/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsSubHeaderTableCell.h"

@implementation CustomerSurveyDetailsSubHeaderTableCell
@synthesize narrative = _narrative;

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
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.narrative.text = aCellData.Field4;
}

@end
