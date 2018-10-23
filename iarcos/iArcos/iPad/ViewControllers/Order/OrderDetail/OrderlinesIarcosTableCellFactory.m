//
//  OrderlinesIarcosTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosTableCellFactory.h"
@interface OrderlinesIarcosTableCellFactory ()

-(OrderlinesIarcosBaseTableViewCell*)getCellWithIdentifier:(NSString*)idendifier;
-(void)calculateCellTypeWithData:(NSMutableDictionary*)theData;

@end

@implementation OrderlinesIarcosTableCellFactory
@synthesize qtyTableCellId = _qtyTableCellId;
@synthesize qtyBonusTableCellId = _qtyBonusTableCellId;
@synthesize qtyDiscTableCellId = _qtyDiscTableCellId;
@synthesize splitQtyTableCellId = _splitQtyTableCellId;
@synthesize splitQtyBonusTableCellId = _splitQtyBonusTableCellId;
@synthesize blankTableCellId = _blankTableCellId;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.qtyTableCellId = @"IdOrderlinesIarcosQtyTableViewCell";
        self.qtyBonusTableCellId = @"IdOrderlinesIarcosQtyBonusTableViewCell";
        self.qtyDiscTableCellId = @"IdOrderlinesIarcosQtyDiscTableViewCell";
        self.splitQtyTableCellId = @"IdOrderlinesIarcosSplitQtyTableViewCell";
        self.splitQtyBonusTableCellId = @"IdOrderlinesIarcosSplitQtyBonusTableViewCell";
        self.blankTableCellId = @"IdOrderlinesIarcosBlankTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.qtyTableCellId = nil;
    self.qtyBonusTableCellId = nil;
    self.qtyDiscTableCellId = nil;
    self.splitQtyTableCellId = nil;
    self.splitQtyBonusTableCellId = nil;
    self.blankTableCellId = nil;
    
    [super dealloc];
}

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(OrderlinesIarcosBaseTableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    OrderlinesIarcosBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"OrderlinesIarcosTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[OrderlinesIarcosBaseTableViewCell class]] && [[(OrderlinesIarcosBaseTableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (OrderlinesIarcosBaseTableViewCell *) nibItem;
            break;
        }
    }
    return cell;
}

-(void)calculateCellTypeWithData:(NSMutableDictionary*)theData {
//    if ([theData objectForKey:@"CellType"] != nil) return;
    NSNumber* cellType = nil;
    if ([[theData objectForKey:@"Qty"] intValue] > 0 && [[theData objectForKey:@"Bonus"] intValue] == 0 && [[theData objectForKey:@"DiscountPercent"] floatValue] == 0) {
        cellType = [NSNumber numberWithInt:1];
    } else if ([[theData objectForKey:@"Bonus"] intValue] != 0) {
        cellType = [NSNumber numberWithInt:2];
    } else if ([[theData objectForKey:@"DiscountPercent"] floatValue] != 0) {
        cellType = [NSNumber numberWithInt:3];
    } else if ([[theData objectForKey:@"Qty"] intValue] == 0 && [[theData objectForKey:@"Bonus"] intValue] == 0 && [[theData objectForKey:@"InStock"] intValue] > 0 && [[theData objectForKey:@"FOC"] intValue] == 0) {
        cellType = [NSNumber numberWithInt:4];
    } else if ([[theData objectForKey:@"Qty"] intValue] == 0 && [[theData objectForKey:@"Bonus"] intValue] == 0 && [[theData objectForKey:@"FOC"] intValue] > 0) {
        cellType = [NSNumber numberWithInt:5];
    } else if ([[theData objectForKey:@"Qty"] intValue] == 0 && [[theData objectForKey:@"Bonus"] intValue] == 0 && [[theData objectForKey:@"DiscountPercent"] floatValue] == 0 && [[theData objectForKey:@"InStock"] intValue] == 0 && [[theData objectForKey:@"FOC"] intValue] == 0) {
        cellType = [NSNumber numberWithInt:6];
    } else {
        cellType = [NSNumber numberWithInt:1];
    }
    [theData setObject:cellType forKey:@"CellType"];
}

- (OrderlinesIarcosBaseTableViewCell*)createOrderlinesIarcosBaseTableViewCellWithData:(NSMutableDictionary*)aData {
    NSString* identifier = [self identifierWithData:aData];
//    NSLog(@"CellType: %@ %@", [aData objectForKey:@"CellType"], identifier);
    return [self getCellWithIdentifier:identifier];
}

-(NSString*)identifierWithData:(NSMutableDictionary*)aData {
    [self calculateCellTypeWithData:aData];
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 1:
            identifier = self.qtyTableCellId;
            break;
        case 2:
            identifier = self.qtyBonusTableCellId;
            break;
        case 3:
            identifier = self.qtyDiscTableCellId;
            break;
        case 4:
            identifier = self.splitQtyTableCellId;
            break;
        case 5:
            identifier = self.splitQtyBonusTableCellId;
            break;
        case 6:
            identifier = self.blankTableCellId;
            break;
            
        default:
            identifier = self.qtyTableCellId;
            break;
    }
    return identifier;
}


@end
