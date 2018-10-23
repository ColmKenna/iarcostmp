//
//  CustomerSurveySubHeaderTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySubHeaderTableCell.h"

@implementation CustomerSurveySubHeaderTableCell
@synthesize narrative = _narrative;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.narrative = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.narrative.text = [self.cellData objectForKey:@"Narrative"];
}

@end
