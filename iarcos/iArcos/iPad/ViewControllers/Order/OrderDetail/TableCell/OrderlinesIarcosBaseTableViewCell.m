//
//  OrderlinesIarcosBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosBaseTableViewCell.h"
#import "ArcosConfigDataManager.h"

@implementation OrderlinesIarcosBaseTableViewCell
@synthesize orderPadDetails = _orderPadDetails;
@synthesize productCode = _productCode;
@synthesize productSize = _productSize;
@synthesize myDescription = _myDescription;
@synthesize value = _value;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.orderPadDetails = nil;
    self.productCode = nil;
    self.productSize = nil;
    self.myDescription = nil;
    self.value = nil;
    
    [super dealloc];
}
/*
 * CellType 
 * 1: normal qty
 * 2: qty bonus
 * 3: qty disc
 * 4: split qty
 * 5: split qty bonus
 */

-(void)configCellWithData:(NSMutableDictionary*)theData {
//    [self configSelectStatus:[[theData objectForKey:@"IsSelected"] boolValue]];
    self.myDescription.text=[theData objectForKey:@"Description"];
    self.orderPadDetails.text = [theData objectForKey:@"OrderPadDetails"];
    self.productSize.text = [theData objectForKey:@"ProductSize"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        self.productCode.text = [theData objectForKey:@"ProductCode"];
    } else {
        self.productCode.text = @"";
    }
//    if ([self.orderPadDetails.text isEqualToString:@""]) {
//        self.productCode.text = @"";
//        self.productSize.text = @"";
//    } else {
//        self.productCode.text = [theData objectForKey:@"ProductCode"];
//        self.productSize.text = [theData objectForKey:@"ProductSize"];
//    }
    self.value.text=[NSString stringWithFormat:@"%1.2f", [[theData objectForKey:@"LineValue"]floatValue]];
}


@end
