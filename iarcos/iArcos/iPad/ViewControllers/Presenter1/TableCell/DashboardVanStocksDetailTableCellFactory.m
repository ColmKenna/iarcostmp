//
//  DashboardVanStocksDetailTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDetailTableCellFactory.h"
@interface DashboardVanStocksDetailTableCellFactory ()

- (DashboardVanStocksDetailBaseTableCell*)getCellWithIdentifier:(NSString*)anIdentifier;

@end

@implementation DashboardVanStocksDetailTableCellFactory
@synthesize readTableCellId = _readTableCellId;
@synthesize writeTableCellId = _writeTableCellId;
@synthesize actionTableCellId = _actionTableCellId;

- (instancetype)init {
    if(self = [super init]) {
        self.readTableCellId = @"IdDashboardVanStocksDetailReadTableCell";
        self.writeTableCellId = @"IdDashboardVanStocksDetailWriteTableCell";
        self.actionTableCellId = @"IdDashboardVanStocksDetailActionTableCell";
    }
    return self;
}

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.readTableCellId = nil;
    self.writeTableCellId = nil;
    self.actionTableCellId = nil;
    
    [super dealloc];
}

- (DashboardVanStocksDetailBaseTableCell*)createVanStocksDetailBaseTableCellWithData:(NSMutableDictionary*)aDataDict {
    return [self getCellWithIdentifier:[self identifierWithData:aDataDict]];
} 

- (DashboardVanStocksDetailBaseTableCell*)getCellWithIdentifier:(NSString*)anIdentifier {
    DashboardVanStocksDetailBaseTableCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardVanStocksDetailTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[DashboardVanStocksDetailBaseTableCell class]] && [[(DashboardVanStocksDetailBaseTableCell*)nibItem reuseIdentifier] isEqualToString: anIdentifier]) {
            cell = (DashboardVanStocksDetailBaseTableCell*)nibItem;
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
            identifier = self.readTableCellId;
            break;
        case 2:
            identifier = self.writeTableCellId;
            break;
        case 3:
            identifier = self.actionTableCellId;
            break;
            
        default:
            identifier = self.readTableCellId;
            break;
    }
    return identifier;
}

@end
