//
//  CustomerSurveyDetailsResponseTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsResponseTableCell.h"

@implementation CustomerSurveyDetailsResponseTableCell
@synthesize narrative = _narrative;
@synthesize response = _response;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;

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
    self.response = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.narrative.text = aCellData.Field4;
    self.response.text = aCellData.Field6;
}

@end
