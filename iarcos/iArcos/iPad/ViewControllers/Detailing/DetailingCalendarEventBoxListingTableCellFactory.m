//
//  DetailingCalendarEventBoxListingTableCellFactory.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingTableCellFactory.h"

@implementation DetailingCalendarEventBoxListingTableCellFactory
@synthesize detailingCalendarEventBoxListingHeaderTableCellId = _detailingCalendarEventBoxListingHeaderTableCellId;
@synthesize detailingCalendarEventBoxListingBodyTableCellId = _detailingCalendarEventBoxListingBodyTableCellId;
@synthesize detailingCalendarEventBoxListingPlaceHolderTableCellId = _detailingCalendarEventBoxListingPlaceHolderTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailingCalendarEventBoxListingHeaderTableCellId = @"IdDetailingCalendarEventBoxListingHeaderTableCell";
        self.detailingCalendarEventBoxListingBodyTableCellId = @"IdDetailingCalendarEventBoxListingBodyTableCell";
        self.detailingCalendarEventBoxListingPlaceHolderTableCellId = @"IdDetailingCalendarEventBoxListingPlaceHolderTableCell";
    }
    return self;
}

- (void)dealloc {
    self.detailingCalendarEventBoxListingHeaderTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyTableCellId = nil;
    self.detailingCalendarEventBoxListingPlaceHolderTableCellId = nil;
    
    [super dealloc];
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* auxIdentifier = nil;
    switch ([cellType intValue]) {
        case 1:
            auxIdentifier = self.detailingCalendarEventBoxListingHeaderTableCellId;
            break;
        case 2:
            auxIdentifier = self.detailingCalendarEventBoxListingBodyTableCellId;
            break;
        case 3:
            auxIdentifier = self.detailingCalendarEventBoxListingPlaceHolderTableCellId;
            break;
            
        default:
            auxIdentifier = self.detailingCalendarEventBoxListingPlaceHolderTableCellId;
            break;
    }
    return auxIdentifier;
}

- (DetailingCalendarEventBoxListingBaseTableCell*)retrieveCellWithIdentifier:(NSString*)anIdendifier {
    DetailingCalendarEventBoxListingBaseTableCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DetailingCalendarEventBoxListingTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[DetailingCalendarEventBoxListingBaseTableCell class]] && [[(DetailingCalendarEventBoxListingBaseTableCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (DetailingCalendarEventBoxListingBaseTableCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (DetailingCalendarEventBoxListingBaseTableCell*)createDetailingCalendarEventBoxListingBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self retrieveCellWithIdentifier:[self identifierWithData:aData]];
}

@end
