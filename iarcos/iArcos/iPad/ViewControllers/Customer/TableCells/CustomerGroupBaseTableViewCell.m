//
//  CustomerGroupBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupBaseTableViewCell.h"

@implementation CustomerGroupBaseTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize descLabel = _descLabel;
@synthesize contentLabel = _contentLabel;
@synthesize indexPath = _indexPath;

- (void)dealloc {
    self.descLabel = nil;
    self.contentLabel = nil;
    self.indexPath = nil;
    
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

- (void)configCellWithData:(NSMutableDictionary*)theData {

}

@end
