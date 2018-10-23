//
//  CustomerIarcosInvoiceDetailsCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosInvoiceDetailsCellFactory.h"
@interface CustomerIarcosInvoiceDetailsCellFactory ()

-(OrderDetailBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation CustomerIarcosInvoiceDetailsCellFactory
@synthesize readLabelTableCellId = _readLabelTableCellId;
@synthesize drillDownTableCellId = _drillDownTableCellId;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.readLabelTableCellId = @"IdOrderDetailReadLabelTableCell";
        self.drillDownTableCellId = @"IdOrderDetailIArcosDrillDownTableCell";
    }
    return self;
}

- (void)dealloc {
    if (self.readLabelTableCellId != nil) { self.readLabelTableCellId = nil; }
    if (self.drillDownTableCellId != nil) { self.drillDownTableCellId = nil; }
    
    [super dealloc];
}

+(id)factory{
    return [[[self alloc]init]autorelease];
}

- (OrderDetailBaseTableCell*)createOrderDetailBaseTableCellWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    OrderDetailBaseTableCell* cell = nil;
    switch ([cellType intValue]) {
        case 2:
            cell = [self createOrderDetailReadLabelTableCell];
            break;
        case 6:
            cell = [self createOrderDetailDrillDownTableCell];
            break;
        default:
            cell = [self createOrderDetailReadLabelTableCell];
            break;
    }
    return cell;
}

-(OrderDetailBaseTableCell*)createOrderDetailReadLabelTableCell {
    return [self getCellWithIdentifier:self.readLabelTableCellId];
}
-(OrderDetailBaseTableCell*)createOrderDetailDrillDownTableCell {
    return [self getCellWithIdentifier:self.drillDownTableCellId];
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
        case 2:
            identifier = self.readLabelTableCellId;
            break;
        case 6:
            identifier = self.drillDownTableCellId;
            break;
            
        default:
            identifier = self.readLabelTableCellId;
            break;
    }
    return identifier;
}

@end
