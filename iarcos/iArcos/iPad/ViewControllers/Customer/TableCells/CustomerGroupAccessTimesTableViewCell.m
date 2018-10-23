//
//  CustomerGroupAccessTimesTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupAccessTimesTableViewCell.h"

@implementation CustomerGroupAccessTimesTableViewCell

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
    [self.actionDelegate selectCustomerGroupAccessTimesRecord:self.contentLabel indexPath:self.indexPath];
}

@end
