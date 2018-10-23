//
//  CustomerSurveyDetailsResponseBaseTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsResponseBaseTableCell.h"

@implementation CustomerSurveyDetailsResponseBaseTableCell
@synthesize delegate = _delegate;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    
}

- (void)dealloc {
    self.cellData = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

@end
