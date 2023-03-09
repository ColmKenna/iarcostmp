//
//  DetailingPPTableCell.m
//  iArcos
//
//  Created by Richard on 03/03/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingPPTableCell.h"

@implementation DetailingPPTableCell
@synthesize myImageView = _myImageView;
@synthesize fullTitleLabel = _fullTitleLabel;
@synthesize memoDetailsLabel = _memoDetailsLabel;
@synthesize shownButton = _shownButton;
@synthesize shownActiveButton = _shownActiveButton;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myImageView = nil;
    self.fullTitleLabel = nil;
    self.memoDetailsLabel = nil;
    self.shownButton = nil;
    self.shownActiveButton = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.myImageView.image = [ArcosUtils genericImageWithIUR:[theData objectForKey:@"ImageIUR"]];
    self.fullTitleLabel.text = [ArcosUtils convertNilToEmpty:[theData objectForKey:@"fullTitle"]];
    self.memoDetailsLabel.text = [ArcosUtils convertNilToEmpty:[theData objectForKey:@"memoDetails"]];
    [self configHideShownButtonWithFlag:[[theData objectForKey:@"data"] boolValue]];
    if ([[theData objectForKey:@"Active"] boolValue]) {
        self.memoDetailsLabel.textColor = [UIColor darkTextColor];
    } else {
        self.memoDetailsLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1.0];
    }
}

- (void)configHideShownButtonWithFlag:(BOOL)aShownButtonHideFlag {
    self.shownButton.hidden = aShownButtonHideFlag;
    self.shownActiveButton.hidden = !aShownButtonHideFlag;
}

- (IBAction)shownButtonPressed:(id)sender {
    if (!self.isEditable) {
        return;
    }
    [self configHideShownButtonWithFlag:YES];
    [self.delegate shownButtonPressedWithValue:YES atIndexPath:self.indexPath];
}

- (IBAction)shownActiveButtonPressed:(id)sender {
    if (!self.isEditable) {
        return;
    }
    [self configHideShownButtonWithFlag:NO];
    [self.delegate shownButtonPressedWithValue:NO atIndexPath:self.indexPath];
}



@end
