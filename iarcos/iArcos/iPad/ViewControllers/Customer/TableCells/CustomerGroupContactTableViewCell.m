//
//  CustomerGroupContactTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 09/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupContactTableViewCell.h"

@implementation CustomerGroupContactTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.descLabel.text = [theData objectForKey:@"Title"];
    NSMutableDictionary* auxAnswerDict = [theData objectForKey:@"Answer"];
    self.contentLabel.text = [auxAnswerDict objectForKey:@"Detail"];
    NSArray* recognizerList = self.contentView.gestureRecognizers;
    for (UITapGestureRecognizer* tmpRecognizer in recognizerList) {
        if ([tmpRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.contentView removeGestureRecognizer:tmpRecognizer];
        }
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(id)sender {
    [self.actionDelegate selectCustomerGroupContactRecord:self.contentLabel indexPath:self.indexPath];
}

@end
