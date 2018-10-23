//
//  SavedIarcosOrderDetailTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailTableCellFactory.h"
@interface SavedIarcosOrderDetailTableCellFactory ()

-(OrderDetailBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation SavedIarcosOrderDetailTableCellFactory
@synthesize dateTableCellId = _dateTableCellId;
@synthesize readLabelTableCellId = _readLabelTableCellId;
@synthesize writeLabelTableCellId = _writeLabelTableCellId;
@synthesize textFieldTableCellId = _textFieldTableCellId;
@synthesize textViewTableCellId = _textViewTableCellId;
@synthesize drillDownTableCellId = _drillDownTableCellId;
@synthesize numberTextFieldTableCellId = _numberTextFieldTableCellId;
@synthesize dateHourMinTableCellId = _dateHourMinTableCellId;
@synthesize iArcosPrintTableCellId = _iArcosPrintTableCellId;
@synthesize deliveryInstructions1TableCellId = _deliveryInstructions1TableCellId;

-(id)init {
    if(self = [super init]) {
        self.dateTableCellId = @"IdOrderDetailDateTableCell";
        self.readLabelTableCellId = @"IdOrderDetailReadLabelTableCell";
        self.writeLabelTableCellId = @"IdOrderDetailWriteLabelTableCell";
        self.textFieldTableCellId = @"IdOrderDetailTextFieldTableCell";
        self.textViewTableCellId = @"IdOrderDetailTextViewTableCell";
        self.drillDownTableCellId = @"IdOrderDetailIArcosDrillDownTableCell";
        self.numberTextFieldTableCellId = @"IdOrderDetailNumberTextFieldTableCell";
        self.dateHourMinTableCellId = @"IdOrderDetailDateHourMinTableCell";
        self.iArcosPrintTableCellId = @"IdOrderDetailIArcosPrintTableCell";
        self.deliveryInstructions1TableCellId = @"IdOrderDetailDeliveryInstructions1TextFieldTableCell";
    }
    return self;
}

- (void)dealloc {
    if (self.dateTableCellId != nil) { self.dateTableCellId = nil; }
    if (self.readLabelTableCellId != nil) { self.readLabelTableCellId = nil; }
    if (self.writeLabelTableCellId != nil) { self.writeLabelTableCellId = nil; }
    if (self.textFieldTableCellId != nil) { self.textFieldTableCellId = nil; }
    if (self.textViewTableCellId != nil) { self.textViewTableCellId = nil; }
    if (self.drillDownTableCellId != nil) { self.drillDownTableCellId = nil; }
    if (self.numberTextFieldTableCellId != nil) { self.numberTextFieldTableCellId = nil; }
    if (self.dateHourMinTableCellId != nil) { self.dateHourMinTableCellId = nil; }
    self.iArcosPrintTableCellId = nil;
    self.deliveryInstructions1TableCellId = nil;
    
    [super dealloc];
}

+(id)factory{
    return [[[self alloc]init]autorelease];
}

- (OrderDetailBaseTableCell*)createOrderDetailBaseTableCellWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    OrderDetailBaseTableCell* cell = nil;
    switch ([cellType intValue]) {
        case 1:
            cell = [self createOrderDetailDateTableCell];
            break;
        case 2:
            cell = [self createOrderDetailReadLabelTableCell];
            break;
        case 3:
            cell = [self createOrderDetailWriteLabelTableCell];
            break;
        case 4:
            cell = [self createOrderDetailTextFieldTableCell];
            break;
        case 5:
            cell = [self createOrderDetailTextViewTableCell];
            break;
        case 6:
            cell = [self createOrderDetailDrillDownTableCell];
            break;
        case 7:
            cell = [self createOrderDetailNumberTextFieldTableCell];
            break;
        case 8:
            cell = [self createOrderDetailDateHourMinTableCell];
            break;
        case 10:
            cell = [self createOrderDetailIArcosPrintTableCell];
            break;
        case 11:
            cell = [self createOrderDetailDeliveryInstructions1TableCell];
            break;
        default:
            cell = [self createOrderDetailReadLabelTableCell];
            break;
    }
    return cell;
}
-(OrderDetailBaseTableCell*)createOrderDetailDateTableCell {
    return [self getCellWithIdentifier:self.dateTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailReadLabelTableCell {
    return [self getCellWithIdentifier:self.readLabelTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailWriteLabelTableCell {
    return [self getCellWithIdentifier:self.writeLabelTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailTextFieldTableCell {
    return [self getCellWithIdentifier:self.textFieldTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailTextViewTableCell {
    return [self getCellWithIdentifier:self.textViewTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDrillDownTableCell {
    return [self getCellWithIdentifier:self.drillDownTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailNumberTextFieldTableCell {
    return [self getCellWithIdentifier:self.numberTextFieldTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDateHourMinTableCell {
    return [self getCellWithIdentifier:self.dateHourMinTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailIArcosPrintTableCell {
    return [self getCellWithIdentifier:self.iArcosPrintTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDeliveryInstructions1TableCell {
    return [self getCellWithIdentifier:self.deliveryInstructions1TableCellId];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailTypesTableCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;
            break;
        }
    }
    return cell;
}

-(NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 1:
            identifier = self.dateTableCellId;
            break;
        case 2:
            identifier = self.readLabelTableCellId;
            break;
        case 3:
            identifier = self.writeLabelTableCellId;
            break;
        case 4:
            identifier = self.textFieldTableCellId;
            break;
        case 5:
            identifier = self.textViewTableCellId;
            break;
        case 6:
            identifier = self.drillDownTableCellId;
            break;
        case 7:
            identifier = self.numberTextFieldTableCellId;
            break;
        case 8:
            identifier = self.dateHourMinTableCellId;
            break;
        case 10:
            identifier = self.iArcosPrintTableCellId;
            break;
        case 11:
            identifier = self.deliveryInstructions1TableCellId;
            break;
            
        default:
            identifier = self.readLabelTableCellId;
            break;
    }
    return identifier;
}

@end
