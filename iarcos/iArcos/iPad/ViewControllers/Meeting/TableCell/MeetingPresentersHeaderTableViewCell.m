//
//  MeetingPresentersHeaderTableViewCell.m
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersHeaderTableViewCell.h"

@implementation MeetingPresentersHeaderTableViewCell

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithMeetingPresentersCompositeObject:(MeetingPresentersCompositeObject*)aMeetingPresentersCompositeObject {
    self.fullTitleLabel.text = aMeetingPresentersCompositeObject.presenterData.Title;
    if ([self.actionDelegate meetingPresenterParentHasShownChild:aMeetingPresentersCompositeObject.presenterData.Locationiur]) {
        self.shownActiveButton.hidden = NO;
    } else {
        self.shownActiveButton.hidden = YES;
    }
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(id)sender {
    
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate presenterHeaderPressedWithIndexPath:self.myIndexPath];
    }
}

@end
