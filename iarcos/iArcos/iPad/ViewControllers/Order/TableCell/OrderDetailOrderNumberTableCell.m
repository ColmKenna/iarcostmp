//
//  OrderDetailOrderNumberTableCell.m
//  iArcos
//
//  Created by Richard on 04/03/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "OrderDetailOrderNumberTableCell.h"

@implementation OrderDetailOrderNumberTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueLabel = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    self.fieldValueLabel.text = [theData objectForKey:@"FieldData"];
    
    if ([[self.cellData objectForKey:@"FieldData"] isEqualToString:@""]) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
    }
    
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) return;
    if ([[self.cellData objectForKey:@"FieldData"] isEqualToString:@""]) return;
    [self.delegate showOrderDetailViewController];
}

@end
