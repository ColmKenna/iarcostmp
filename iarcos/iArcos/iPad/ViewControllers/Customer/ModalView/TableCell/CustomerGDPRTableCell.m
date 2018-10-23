//
//  CustomerGDPRTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerGDPRTableCell.h"

@implementation CustomerGDPRTableCell
@synthesize actionDelegate = _actionDelegate;
@synthesize fieldDesc = _fieldDesc;
@synthesize radioButton = _radioButton;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldDesc = nil;
    self.radioButton = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.fieldDesc.text = [aCellData objectForKey:@"Title"];
    NSNumber* tickFlag = [aCellData objectForKey:@"TickFlag"];
    if ([tickFlag boolValue]) {
        //radiobutton_yes.png radiobutton_no.png
        [self.radioButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
    } else {
        [self.radioButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)radioButtonPressed:(id)sender {
    [self.actionDelegate radioButtonPressedWithIndexPath:self.indexPath];
}

@end
