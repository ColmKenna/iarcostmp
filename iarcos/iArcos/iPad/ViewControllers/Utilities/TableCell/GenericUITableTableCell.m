//
//  GenericUITableTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 18/07/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "GenericUITableTableCell.h"

@implementation GenericUITableTableCell
@synthesize cellLabelList = _cellLabelList;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellLabelList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    for (int i = 0; i < [self.cellLabelList count]; i++) {
        UILabel* cellLabel = [self.cellLabelList objectAtIndex:i];
        [cellLabel removeFromSuperview];
    }
    self.cellLabelList = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
