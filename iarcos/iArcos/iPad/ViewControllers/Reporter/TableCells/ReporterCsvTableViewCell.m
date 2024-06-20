//
//  ReporterCsvTableViewCell.m
//  iArcos
//
//  Created by Richard on 18/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReporterCsvTableViewCell.h"

@implementation ReporterCsvTableViewCell
@synthesize cellLabelList = _cellLabelList;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    NSLog(@"r csv dealloc %ld", [self.cellLabelList count]);
    for (int i = 0; i < [self.cellLabelList count]; i++) {
        UILabel* cellLabel = [self.cellLabelList objectAtIndex:i];
        [cellLabel removeFromSuperview];
    }
    self.cellLabelList = nil;
    [super dealloc];
}

@end
