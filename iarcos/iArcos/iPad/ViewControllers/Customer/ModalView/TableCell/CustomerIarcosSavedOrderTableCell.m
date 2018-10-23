//
//  CustomerIarcosSavedOrderTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosSavedOrderTableCell.h"
#import "ArcosCoreData.h"

@implementation CustomerIarcosSavedOrderTableCell
@synthesize delegate = _delegate;
@synthesize orderDate = _orderDate;
@synthesize deliveryDate = _deliveryDate;
@synthesize name = _name;
@synthesize typeDesc = _typeDesc;
@synthesize value = _value;
@synthesize employeeName = _employeeName;
@synthesize sendButton = _sendButton;
@synthesize myImageViewType = _myImageViewType;
@synthesize indicator = _indicator;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.orderDate = nil;
    self.deliveryDate = nil;
    self.name = nil;
    self.typeDesc = nil;
    self.value = nil;
    self.employeeName = nil;
    self.sendButton = nil;
    self.myImageViewType = nil;
    self.indicator = nil;
    self.cellData = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)cellData {
    self.cellData = cellData;
    self.orderDate.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"OrderDate"] format:[GlobalSharedClass shared].dateFormat];
    self.employeeName.text = [cellData objectForKey:@"Employee"];
    
    BOOL hideSendBtnFlag = [[cellData objectForKey:@"IsSealed"] boolValue];
    self.sendButton.hidden = hideSendBtnFlag;
    self.myImageViewType.hidden = !hideSendBtnFlag;
    
    if ([[cellData objectForKey:@"NumberOflines"] intValue] == 0) {
        self.deliveryDate.hidden = YES;
        self.value.hidden = YES;
        if ([[cellData objectForKey:@"ContactIUR"] intValue] == 0) {
            self.name.text = [cellData objectForKey:@"LocationNameText"];
        } else {
            self.name.text = [cellData objectForKey:@"ContactNameText"];
        }
        self.typeDesc.text = [cellData objectForKey:@"CallTypeText"];
        if ([[cellData objectForKey:@"IsSealed"] boolValue]) {
            UIImage* auxCTiurImage = nil;
            NSDictionary* cTiurDescrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:[cellData objectForKey:@"CTiur"]];
            NSNumber* cTiurImageIUR = [cTiurDescrDetailDict objectForKey:@"ImageIUR"];
            if ([cTiurImageIUR intValue] > 0) {
                auxCTiurImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:cTiurImageIUR];
            }
            if (auxCTiurImage == nil) {
                self.myImageViewType.image = [UIImage imageNamed:@"Memo_sent"];
            } else {
                self.myImageViewType.image = auxCTiurImage;
            }
        }
    } else {
        self.deliveryDate.hidden = NO;
        self.value.hidden = NO;
        self.deliveryDate.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"DeliveryDate"] format:[GlobalSharedClass shared].dateFormat];
        self.value.text = [NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"TotalGoods"]floatValue]];
        self.name.text = [cellData objectForKey:@"WholesaleNameText"];
        self.typeDesc.text = [cellData objectForKey:@"OrderTypeText"];
        if ([[cellData objectForKey:@"IsSealed"] boolValue]) {
            UIImage* auxWholesalerImage = nil;
            NSNumber* auxWholesaleIUR = [cellData objectForKey:@"WholesaleIUR"];
            NSMutableArray* wholeSalerDictList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:auxWholesaleIUR];
            if (wholeSalerDictList != nil) {
                NSDictionary* auxWholesalerDict = [wholeSalerDictList objectAtIndex:0];
                NSNumber* auxWholesalerImageIUR = [auxWholesalerDict objectForKey:@"ImageIUR"];
                if ([auxWholesalerImageIUR intValue] > 0) {
                    auxWholesalerImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:auxWholesalerImageIUR];
                }
            }
            if (auxWholesalerImage == nil) {
                self.myImageViewType.image = [UIImage imageNamed:@"Order_sent"];
            } else {
                self.myImageViewType.image = auxWholesalerImage;
            }
        }
    }
}

- (IBAction)sendOrder:(id)sender{
    UIButton* aButton = (UIButton*)sender;
    aButton.hidden=YES;
    aButton.enabled=NO;
    [self.delegate sendPressedForCell:self];
}

- (void)animate {
    self.userInteractionEnabled=NO;
    self.indicator.hidden=NO;
    [self.indicator startAnimating];
}

- (void)inSending:(BOOL)sending {
    if (sending) {
        self.userInteractionEnabled=NO;
        [self.indicator startAnimating];
        self.sendButton.hidden=YES;
    }else{
        self.userInteractionEnabled=YES;
        [self.indicator stopAnimating];
        self.sendButton.enabled=YES;
    }
}

- (void)stopAnimateWithStatus:(BOOL)status {
    self.userInteractionEnabled=YES;
    self.sendButton.hidden=status;
    self.sendButton.enabled=status;
    [self.indicator stopAnimating];
}

-(void)needEditable:(BOOL)editable{
    self.editing=!editable;
    self.sendButton.hidden=!editable;
    
    if (!editable) {
        
    }else{
        self.sendButton.enabled=YES;
    }
}

@end
