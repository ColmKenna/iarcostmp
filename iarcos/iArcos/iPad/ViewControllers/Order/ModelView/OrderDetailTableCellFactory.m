//
//  OrderDetailTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailTableCellFactory.h"
@interface OrderDetailTableCellFactory (Private)

-(OrderDetailBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation OrderDetailTableCellFactory
@synthesize dateTableCellId = _dateTableCellId;
@synthesize readLabelTableCellId = _readLabelTableCellId;
@synthesize writeLabelTableCellId = _writeLabelTableCellId;
@synthesize textFieldTableCellId = _textFieldTableCellId;
@synthesize textViewTableCellId = _textViewTableCellId;
@synthesize drillDownTableCellId = _drillDownTableCellId;
@synthesize numberTextFieldTableCellId = _numberTextFieldTableCellId;
@synthesize dateHourMinTableCellId = _dateHourMinTableCellId;
@synthesize printTableCellId = _printTableCellId;
@synthesize deliveryInstructions1TableCellId = _deliveryInstructions1TableCellId;
@synthesize formTypeLabelTableCellId = _formTypeLabelTableCellId;
@synthesize locationLabelTableCellId = _locationLabelTableCellId;

-(id)init {
    if(self = [super init]) {
        self.dateTableCellId = @"IdOrderDetailDateTableCell";
        self.readLabelTableCellId = @"IdOrderDetailReadLabelTableCell";
        self.writeLabelTableCellId = @"IdOrderDetailWriteLabelTableCell";
        self.textFieldTableCellId = @"IdOrderDetailTextFieldTableCell";
        self.textViewTableCellId = @"IdOrderDetailTextViewTableCell";
        self.drillDownTableCellId = @"IdOrderDetailDrillDownTableCell";
        self.numberTextFieldTableCellId = @"IdOrderDetailNumberTextFieldTableCell";
        self.dateHourMinTableCellId = @"IdOrderDetailDateHourMinTableCell";
        self.printTableCellId = @"IdOrderDetailPrintTableCell";
        self.deliveryInstructions1TableCellId = @"IdOrderDetailDeliveryInstructions1TextFieldTableCell";
        self.formTypeLabelTableCellId = @"IdOrderDetailFormTypeLabelTableCell";
        self.locationLabelTableCellId = @"IdOrderDetailLocationLabelTableCell";
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
    self.printTableCellId = nil;
    self.deliveryInstructions1TableCellId = nil;
    self.formTypeLabelTableCellId = nil;
    self.locationLabelTableCellId = nil;
    
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
        case 9:
            cell = [self createOrderDetailPrintTableCell];
            break;
        case 11:
            cell = [self createOrderDetailDeliveryInstructions1TableCell];
            break;
        case 12:
            cell = [self createOrderDetailFormTypeLabelTableCell];
            break;
        case 15:
            cell = [self createOrderDetailLocationLabelTableCell];
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
-(OrderDetailBaseTableCell*)createOrderDetailPrintTableCell {
    return [self getCellWithIdentifier:self.printTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailNumberTextFieldTableCell {
    return [self getCellWithIdentifier:self.numberTextFieldTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDateHourMinTableCell {
    return [self getCellWithIdentifier:self.dateHourMinTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDeliveryInstructions1TableCell {
    return [self getCellWithIdentifier:self.deliveryInstructions1TableCellId];
}
- (OrderDetailBaseTableCell*)createOrderDetailFormTypeLabelTableCell {
    return [self getCellWithIdentifier:self.formTypeLabelTableCellId];
}
- (OrderDetailBaseTableCell*)createOrderDetailLocationLabelTableCell {
    return [self getCellWithIdentifier:self.locationLabelTableCellId];
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
        case 9:
            identifier = self.printTableCellId;
            break;
        case 11:
            identifier = self.deliveryInstructions1TableCellId;
            break;
        case 12:
            identifier = self.formTypeLabelTableCellId;
            break;
        case 15:
            identifier = self.locationLabelTableCellId;
            break;
            
        default:
            identifier = self.readLabelTableCellId;
            break;
    }
    return identifier;
}

@end
