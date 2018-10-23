//
//  DetailingPresenterTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 23/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DetailingPresenterTableCell.h"

@implementation DetailingPresenterTableCell
@synthesize label = _label;
@synthesize statusLabel = _statusLabel;

- (void)dealloc {
    self.label = nil;
    self.statusLabel = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.label.text = [theData objectForKey:@"Label"];
//    NSNumber* answerData = [theData objectForKey:@"data"];
    self.statusLabel.text = [theData objectForKey:@"data"];
}

@end
