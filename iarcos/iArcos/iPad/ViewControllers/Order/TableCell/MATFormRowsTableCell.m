//
//  MATFormRowsTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 26/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "MATFormRowsTableCell.h"

@implementation MATFormRowsTableCell
/*
@synthesize details;
@synthesize field3;
@synthesize field4;
@synthesize field5;
@synthesize field6;
@synthesize field7;
@synthesize field8;
@synthesize field9;
@synthesize field10;
@synthesize field11;
@synthesize field12;
@synthesize field13;
@synthesize field14;
@synthesize field15;
@synthesize field16;
@synthesize qty;
@synthesize bon;
*/
@synthesize cellFormRowData = _cellFormRowData;
@synthesize indexPath = _indexPath;
//@synthesize selectIndicator;
//@synthesize selectedIndicator;

@synthesize labelSelectedIndicator;
@synthesize labelDividerBeforeDetails;
@synthesize orderPadDetails;
@synthesize productCode;
@synthesize productSize;
@synthesize labelDetails;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize label7;
@synthesize label8;
@synthesize label9;
@synthesize label10;
@synthesize label11;
@synthesize label12;
@synthesize label13;
@synthesize label14;
@synthesize label15;
@synthesize labelDividerAfter15;
@synthesize label16;
@synthesize labelDividerAfter16;
@synthesize labelQty;
//@synthesize labelDividerAfterQty;
@synthesize labelBon;
@synthesize labelStock;
@synthesize labelSRP;
@synthesize labelPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
/*    
    if (self.details != nil) { self.details = nil; }    
    if (self.field3 != nil) { self.field3 = nil; }
    if (self.field4 != nil) { self.field4 = nil; }    
    if (self.field5 != nil) { self.field5 = nil; }
    if (self.field6 != nil) { self.field6 = nil; }
    if (self.field7 != nil) { self.field7 = nil; }
    if (self.field8 != nil) { self.field8 = nil; }
    if (self.field9 != nil) { self.field9 = nil; }
    if (self.field10 != nil) { self.field10 = nil; }
    if (self.field11 != nil) { self.field11 = nil; }
    if (self.field12 != nil) { self.field12 = nil; }
    if (self.field13 != nil) { self.field13 = nil; }    
    if (self.field14 != nil) { self.field14 = nil; }
    if (self.field15 != nil) { self.field15 = nil; }
    if (self.field16 != nil) { self.field16 = nil; }    
    if (self.qty != nil) { self.qty = nil; }
    if (self.bon != nil) { self.bon = nil; }
*/ 
    if (self.cellFormRowData != nil) { self.cellFormRowData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
//    if (self.selectIndicator != nil) { self.selectIndicator = nil; }
//    if (self.selectedIndicator != nil) { self.selectedIndicator = nil; }    
    
    if (self.labelSelectedIndicator != nil) { self.labelSelectedIndicator = nil; }
    if (self.labelDividerBeforeDetails != nil) { self.labelDividerBeforeDetails = nil; }
    if (self.orderPadDetails != nil) { self.orderPadDetails = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.productSize != nil) { self.productSize = nil; }
    if (self.labelDetails != nil) { self.labelDetails = nil; }
    if (self.label3 != nil) { self.label3 = nil; }
    if (self.label4 != nil) { self.label4 = nil; }    
    if (self.label5 != nil) { self.label5 = nil; }
    if (self.label6 != nil) { self.label6 = nil; }
    if (self.label7 != nil) { self.label7 = nil; }
    if (self.label8 != nil) { self.label8 = nil; }
    if (self.label9 != nil) { self.label9 = nil; }    
    if (self.label10 != nil) { self.label10 = nil; }
    if (self.label11 != nil) { self.label11 = nil; }
    if (self.label12 != nil) { self.label12 = nil; }
    if (self.label13 != nil) { self.label13 = nil; }
    if (self.label14 != nil) { self.label14 = nil; }    
    if (self.label15 != nil) { self.label15 = nil; }
    if (self.labelDividerAfter15 != nil) { self.labelDividerAfter15 = nil; }    
    if (self.label16 != nil) { self.label16 = nil; }
    if (self.labelDividerAfter16 != nil) { self.labelDividerAfter16 = nil; }    
    if (self.labelQty != nil) { self.labelQty = nil; }
//    if (self.labelDividerAfterQty != nil) { self.labelDividerAfterQty = nil; }    
    if (self.labelBon != nil) { self.labelBon = nil; }
    self.labelStock = nil;
    self.labelSRP = nil;
    self.labelPrice = nil;
    
    [super dealloc];
}

-(void)initIndicatorBorder {
//    [self.selectIndicator.layer setBorderColor: [[UIColor blackColor] CGColor]];
//    [self.selectIndicator.layer setBorderWidth: 1.0];       
    
}

-(void)setSelectStatus:(BOOL)select {
    isSelected = select;
    if (isSelected) {
//        self.selectIndicator.backgroundColor = [UIColor redColor];        
//        self.selectedIndicator.backgroundColor = [UIColor redColor];
    } else {
//        self.selectIndicator.backgroundColor = [UIColor whiteColor];
//        self.selectedIndicator.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setCellSelectStatus:(BOOL)select {
    isSelected = select;
    if (isSelected) {                
        self.labelSelectedIndicator.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:.2];
    } else {
        self.labelSelectedIndicator.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
