//
//  ArcosCalendarEventEntryDetailTextViewTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailTextViewTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailTextViewTableViewCell
@synthesize fieldValueTextView = _fieldValueTextView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldValueTextView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.fieldValueTextView.text = [aCellData objectForKey:@"FieldData"];
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.actionDelegate detailBaseInputFinishedWithData:textView.text atIndexPath:self.myIndexPath];
}

@end
