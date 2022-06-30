//
//  ArcosCalendarEventEntryDetailTableViewCellFactory.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailTableViewCellFactory.h"

@implementation ArcosCalendarEventEntryDetailTableViewCellFactory
@synthesize textFieldTableCellId = _textFieldTableCellId;
@synthesize textViewTableCellId = _textViewTableCellId;
@synthesize switchTableCellId = _switchTableCellId;
@synthesize dateTableCellId = _dateTableCellId;
@synthesize datetimeTableCellId = _datetimeTableCellId;
@synthesize deleteTableCellId = _deleteTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textFieldTableCellId = @"IdArcosCalendarEventEntryDetailTextFieldTableViewCell";
        self.textViewTableCellId = @"IdArcosCalendarEventEntryDetailTextViewTableViewCell";
        self.switchTableCellId = @"IdArcosCalendarEventEntryDetailSwitchTableViewCell";
        self.dateTableCellId = @"IdArcosCalendarEventEntryDetailDateTableViewCell";
        self.datetimeTableCellId = @"IdArcosCalendarEventEntryDetailDateTimeTableViewCell";
        self.deleteTableCellId = @"IdArcosCalendarEventEntryDetailDeleteTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.textFieldTableCellId = nil;
    self.textViewTableCellId = nil;
    self.switchTableCellId = nil;
    self.dateTableCellId = nil;
    self.datetimeTableCellId = nil;
    self.deleteTableCellId = nil;
    
    [super dealloc];
}

- (ArcosCalendarEventEntryDetailBaseTableViewCell*)createEventEntryDetailBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self retrieveCellWithIdentifier:[self identifierWithData:aData]];
}

- (ArcosCalendarEventEntryDetailBaseTableViewCell*)retrieveCellWithIdentifier:(NSString*)anIdendifier {
    ArcosCalendarEventEntryDetailBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosCalendarEventEntryDetailMainTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[ArcosCalendarEventEntryDetailBaseTableViewCell class]] && [[(ArcosCalendarEventEntryDetailBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (ArcosCalendarEventEntryDetailBaseTableViewCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* auxIdentifier = nil;
    switch ([cellType intValue]) {
        case 1:
            auxIdentifier = self.textFieldTableCellId;
            break;
        case 2:
            auxIdentifier = self.textViewTableCellId;
            break;
        case 3:
            auxIdentifier = self.switchTableCellId;
            break;
        case 4:
            auxIdentifier = self.dateTableCellId;
            break;
        case 5:
            auxIdentifier = self.datetimeTableCellId;
            break;
        case 6:
            auxIdentifier = self.deleteTableCellId;
            break;
            
        default:
            auxIdentifier = self.textFieldTableCellId;
            break;
    }
    return auxIdentifier;
}

@end
