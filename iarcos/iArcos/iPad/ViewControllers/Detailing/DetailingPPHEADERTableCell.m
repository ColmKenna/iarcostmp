//
//  DetailingPPHEADERTableCell.m
//  iArcos
//
//  Created by Richard on 03/03/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingPPHEADERTableCell.h"

@implementation DetailingPPHEADERTableCell
@synthesize descLabel = _descLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.descLabel = nil;
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.descLabel.text = [ArcosUtils convertNilToEmpty:[theData objectForKey:@"Detail"]];
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate presenterHeaderPressedWithIndexPath:self.indexPath];
    }
}

@end
