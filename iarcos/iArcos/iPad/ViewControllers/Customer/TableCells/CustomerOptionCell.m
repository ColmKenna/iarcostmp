//
//  CusomerOptionCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerOptionCell.h"

@implementation CustomerOptionCell
@synthesize optionIcon;
@synthesize optionTitle;
@synthesize optionAddBut;
@synthesize optionDetail;
@synthesize delegate;

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

-(IBAction)AddButtonAction:(id)sender{
    UIButton* but=(UIButton*)sender;
    
    [self.delegate AddButtonPressed:but.tag];
}

- (void)dealloc {
    if (self.optionIcon != nil) { self.optionIcon = nil; }
    if (self.optionTitle != nil) { self.optionTitle = nil; }
    if (self.optionAddBut != nil) { self.optionAddBut = nil; }
    if (self.optionDetail != nil) { self.optionDetail = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    
    [super dealloc];
}
@end
