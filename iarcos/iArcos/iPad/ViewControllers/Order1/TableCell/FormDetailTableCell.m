//
//  FormDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 30/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "FormDetailTableCell.h"

@implementation FormDetailTableCell
@synthesize myImageView = _myImageView;
@synthesize myTextLabel = _myTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.myImageView != nil) { self.myImageView = nil; }
    if (self.myTextLabel != nil) { self.myTextLabel = nil; }  
    
    [super dealloc];
}

- (void)configImageView {
    self.myImageView.layer.masksToBounds = YES;
    [self.myImageView.layer setCornerRadius:5.0f];
}

@end
