//
//  DashboardVanStocksDetailActionTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDetailActionTableCell.h"

@implementation DashboardVanStocksDetailActionTableCell
@synthesize actionButton = _actionButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.actionButton = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    [self.actionButton setTitle:[aDataDict objectForKey:@"FieldName"] forState:UIControlStateNormal];
}

- (IBAction)updateButtonPressed:(id)sender {
    [self.actionDelegate updateButtonPressedDelegate];
}

@end
