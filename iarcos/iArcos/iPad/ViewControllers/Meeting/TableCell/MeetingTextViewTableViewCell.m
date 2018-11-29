//
//  MeetingTextViewTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingTextViewTableViewCell.h"

@implementation MeetingTextViewTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextView = _fieldValueTextView;
@synthesize styleSetFlag = _styleSetFlag;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    if (!self.styleSetFlag) {
        [self.fieldValueTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.fieldValueTextView.layer setBorderWidth:0.5];
        [self.fieldValueTextView.layer setCornerRadius:5.0f];
        self.styleSetFlag = YES;
    }
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    self.fieldValueTextView.text = [aCellData objectForKey:@"FieldData"];
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueTextView = nil;
    
    [super dealloc];
}

@end
