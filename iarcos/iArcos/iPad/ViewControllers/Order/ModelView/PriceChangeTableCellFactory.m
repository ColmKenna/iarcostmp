//
//  PriceChangeTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeTableCellFactory.h"
@interface PriceChangeTableCellFactory ()

- (PriceChangeBaseTableCell*)getCellWithIdentifier:(NSString*)anIdentifier;

@end

@implementation PriceChangeTableCellFactory
@synthesize readableTableCellId = _readableTableCellId;
@synthesize writableTableCellId = _writableTableCellId;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.readableTableCellId = @"IdPriceChangeReadableTableCell";
        self.writableTableCellId = @"IdPriceChangeWritableTableCell";
    }
    return self;
}

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.readableTableCellId = nil;
    self.writableTableCellId = nil;
    
    [super dealloc];
}

- (PriceChangeBaseTableCell*)createPriceChangeBaseTableCellWithData:(NSMutableDictionary*)aDataDict {
    return [self getCellWithIdentifier:[self identifierWithData:aDataDict]];
} 

- (PriceChangeBaseTableCell*)getCellWithIdentifier:(NSString*)anIdentifier {
    PriceChangeBaseTableCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"PriceChangeTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[PriceChangeBaseTableCell class]] && [[(PriceChangeBaseTableCell*)nibItem reuseIdentifier] isEqualToString:anIdentifier]) {
            cell = (PriceChangeBaseTableCell*)nibItem;
            break;
        }
    }    
    return cell;
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aDataDict {
    NSNumber* cellType = [aDataDict objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 1:
            identifier = self.readableTableCellId;
            break;
        case 2:
            identifier = self.writableTableCellId;
            break;
            
        default:
            identifier = self.readableTableCellId;
            break;
    }
    return identifier;
}

@end
