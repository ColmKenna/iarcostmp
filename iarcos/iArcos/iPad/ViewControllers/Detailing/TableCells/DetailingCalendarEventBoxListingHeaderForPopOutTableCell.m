//
//  DetailingCalendarEventBoxListingHeaderForPopOutTableCell.m
//  iArcos
//
//  Created by Richard on 21/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingHeaderForPopOutTableCell.h"

@implementation DetailingCalendarEventBoxListingHeaderForPopOutTableCell

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
    for (UIGestureRecognizer* recognizer in self.fieldDescLabel.gestureRecognizers) {
        [self.fieldDescLabel removeGestureRecognizer:recognizer];
    }
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.minimumPressDuration = 1.0;
    [self.fieldDescLabel addGestureRecognizer:longPress];
    [longPress release];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.actionDelegate longInputForPopOutFinishedWithIndexPath:self.myIndexPath];
    }
}

@end
