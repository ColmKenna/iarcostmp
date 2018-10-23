//
//  OrderDetailPrintTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 09/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "OrderDetailPrintTableCell.h"

@implementation OrderDetailPrintTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize isEventSet = _isEventSet;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.fieldNameLabel = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
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
