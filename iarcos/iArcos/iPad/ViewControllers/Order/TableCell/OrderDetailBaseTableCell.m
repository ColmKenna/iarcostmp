//
//  OrderDetailBaseTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailBaseTableCell.h"

@implementation OrderDetailBaseTableCell
@synthesize delegate = _delegate;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;
@synthesize isNotEditable = _isNotEditable;

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

/*
 *DataStructure Specification
 *CellType nsnumber 1:DateCell 2:readLabelCell 3:writeLabelCell 4:textFieldCell 5:TextViewCell 6:DrillDownCell
 *CellKey nsstring key from orderheader
 *FieldNameLabel nsstring fieldName displayed
 *FieldData id NSDate or NSString or NSMutableDictionary
 * -DateCell NSDate
 * -readLabelCell textFieldCell TextViewCell NSString
 * -writeLabelCell NSMutableDictionary
 *WriteType NSNumber according to the value defined in WidgetDataSource 
 * -0:delivery date label 
 * -1:order date label
 * -4:wholesaler label
 * -3:status label
 * -5:type label
 * -7:contact label
 * -6:call type label
 *OrderHeaderType 1:Order 2:Call
 */
- (void)configCellWithData:(NSMutableDictionary*)theData {
    
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }    
    
    [super dealloc];
}

@end
