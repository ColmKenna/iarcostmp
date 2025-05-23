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
@synthesize detailingCalendarEventBoxListingBodyForTemplateTableCellId = _detailingCalendarEventBoxListingBodyForTemplateTableCellId;
@synthesize detailingCalendarEventBoxListingBodyJourneyForTemplateTableCellId = _detailingCalendarEventBoxListingBodyJourneyForTemplateTableCellId;
@synthesize detailingCalendarEventBoxListingHeaderForPopOutTableCellId = _detailingCalendarEventBoxListingHeaderForPopOutTableCellId;
@synthesize detailingCalendarEventBoxListingBodyForPopOutTableCellId = _detailingCalendarEventBoxListingBodyForPopOutTableCellId;
@synthesize detailingCalendarEventBoxListingBodyJourneyForPopOutTableCellId = _detailingCalendarEventBoxListingBodyJourneyForPopOutTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailingCalendarEventBoxListingHeaderTableCellId = @"IdDetailingCalendarEventBoxListingHeaderTableCell";
        self.detailingCalendarEventBoxListingBodyTableCellId = @"IdDetailingCalendarEventBoxListingBodyTableCell";
        self.detailingCalendarEventBoxListingPlaceHolderTableCellId = @"IdDetailingCalendarEventBoxListingPlaceHolderTableCell";
        self.detailingCalendarEventBoxListingBodyForTemplateTableCellId = @"IdDetailingCalendarEventBoxListingBodyForTemplateTableCell";
        self.detailingCalendarEventBoxListingBodyJourneyForTemplateTableCellId = @"IdDetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell";
        self.detailingCalendarEventBoxListingHeaderForPopOutTableCellId = @"IdDetailingCalendarEventBoxListingHeaderForPopOutTableCell";
        self.detailingCalendarEventBoxListingBodyForPopOutTableCellId = @"IdDetailingCalendarEventBoxListingBodyForPopOutTableCell";
        self.detailingCalendarEventBoxListingBodyJourneyForPopOutTableCellId = @"IdDetailingCalendarEventBoxListingBodyJourneyForPopOutTableCell";
    }
    return self;
}

- (void)dealloc {
    self.detailingCalendarEventBoxListingHeaderTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyTableCellId = nil;
    self.detailingCalendarEventBoxListingPlaceHolderTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyForTemplateTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyJourneyForTemplateTableCellId = nil;
    self.detailingCalendarEventBoxListingHeaderForPopOutTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyForPopOutTableCellId = nil;
    self.detailingCalendarEventBoxListingBodyJourneyForPopOutTableCellId = nil;
    
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
        case 4:
            auxIdentifier = self.detailingCalendarEventBoxListingBodyForTemplateTableCellId;
            break;
        case 5:
            auxIdentifier = self.detailingCalendarEventBoxListingBodyJourneyForTemplateTableCellId;
            break;
        case 6:
            auxIdentifier = self.detailingCalendarEventBoxListingHeaderForPopOutTableCellId;
            break;
        case 7:
            auxIdentifier = self.detailingCalendarEventBoxListingBodyForPopOutTableCellId;
            break;
        case 8:
            auxIdentifier = self.detailingCalendarEventBoxListingBodyJourneyForPopOutTableCellId;
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
