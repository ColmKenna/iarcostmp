//
//  OrderDetailIArcosPrintTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 24/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "OrderDetailIArcosPrintTableCell.h"

@implementation OrderDetailIArcosPrintTableCell
@synthesize printButton = _printButton;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize isEventSet = _isEventSet;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.printButton = nil;
    self.fieldNameLabel = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self.printButton setImage:[UIImage imageNamed:@"Email.png"] forState:UIControlStateNormal];
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    if (!self.isEventSet) {
        self.isEventSet = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.contentView addGestureRecognizer:singleTap];
        [singleTap release];
    }
}

-(void)handleSingleTapGesture:(id)sender {
    [self.delegate showPrintViewControllerDelegate];
}

@end
