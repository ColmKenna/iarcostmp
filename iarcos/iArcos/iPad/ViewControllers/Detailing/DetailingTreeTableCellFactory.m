//
//  DetailingTreeTableCellFactory.m
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTreeTableCellFactory.h"

@implementation DetailingTreeTableCellFactory
@synthesize branchTableCellId = _branchTableCellId;
@synthesize leafTableCellId = _leafTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.branchTableCellId = @"IdDetailingTreeBranchTableCell";
        self.leafTableCellId = @"IdDetailingTreeLeafTableCell";
    }
    return self;
}

- (void)dealloc {
    self.branchTableCellId = nil;
    self.leafTableCellId = nil;
    
    [super dealloc];
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* auxIdentifier = nil;
    switch ([cellType intValue]) {
        case 1:
            auxIdentifier = self.branchTableCellId;
            break;
        case 2:
            auxIdentifier = self.leafTableCellId;
            break;
            
        default:
            auxIdentifier = self.branchTableCellId;
            break;
    }
    return auxIdentifier;
}

- (DetailingTreeBaseTableCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    DetailingTreeBaseTableCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DetailingTreeTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[DetailingTreeBaseTableCell class]] && [[(DetailingTreeBaseTableCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (DetailingTreeBaseTableCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (DetailingTreeBaseTableCell*)createDetailingTreeBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

@end
