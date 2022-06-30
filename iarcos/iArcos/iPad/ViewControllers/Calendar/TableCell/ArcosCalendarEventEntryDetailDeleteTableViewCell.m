//
//  ArcosCalendarEventEntryDetailDeleteTableViewCell.m
//  iArcos
//
//  Created by Richard on 22/06/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailDeleteTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailDeleteTableViewCell
@synthesize fieldDescLabel = _fieldDescLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.fieldDescLabel.gestureRecognizers) {
        [self.fieldDescLabel removeGestureRecognizer:recognizer];
    }
    self.fieldDescLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    for (UIGestureRecognizer* recognizer in self.fieldDescLabel.gestureRecognizers) {
        [self.fieldDescLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldDescLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate detailDeleteButtonPressed];
    }
}

@end
