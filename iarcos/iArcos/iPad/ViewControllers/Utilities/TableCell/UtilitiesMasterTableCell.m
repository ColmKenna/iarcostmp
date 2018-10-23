//
//  UtilitiesMasterTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 16/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMasterTableCell.h"

@implementation UtilitiesMasterTableCell
@synthesize myImageView = _myImageView;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;

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

- (void)dealloc {
    if (self.myImageView != nil) { self.myImageView = nil; }
    if (self.titleLabel != nil) { self.titleLabel = nil; }
    if (self.subTitleLabel != nil) { self.subTitleLabel = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.myImageView.layer.masksToBounds = YES;
    [self.myImageView.layer setCornerRadius:5.0f];
    self.myImageView.image = [UIImage imageNamed:[theData objectForKey:@"FileName"]];
    self.titleLabel.text = [theData objectForKey:@"Title"];
    self.subTitleLabel.text = [theData objectForKey:@"SubTitle"];
}

@end
