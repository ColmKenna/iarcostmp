//
//  CustomerGroupBuyingGroupTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 26/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupBuyingGroupTableViewCell.h"

@implementation CustomerGroupBuyingGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [self.actionDelegate selectCustomerGroupBuyingGroupRecord:self.contentLabel indexPath:self.indexPath];
}

@end
