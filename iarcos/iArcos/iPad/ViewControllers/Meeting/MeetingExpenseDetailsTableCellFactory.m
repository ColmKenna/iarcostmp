//
//  MeetingExpenseDetailsTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsTableCellFactory.h"

@implementation MeetingExpenseDetailsTableCellFactory
@synthesize iurTableCellId = _iurTableCellId;
@synthesize dateTableCellId = _dateTableCellId;
@synthesize textTableCellId = _textTableCellId;
@synthesize decimalTableCellId = _decimalTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.iurTableCellId = @"IdMeetingExpenseDetailsIURTableViewCell";
        self.dateTableCellId = @"IdMeetingExpenseDetailsDateTableViewCell";
        self.textTableCellId = @"IdMeetingExpenseDetailsTextTableViewCell";
        self.decimalTableCellId = @"IdMeetingExpenseDetailsDecimalTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.iurTableCellId = nil;
    self.dateTableCellId = nil;
    self.textTableCellId = nil;
    self.decimalTableCellId = nil;
    
    [super dealloc];
}

- (MeetingExpenseDetailsBaseTableViewCell*)createMeetingExpenseDetailsBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

- (MeetingExpenseDetailsBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    MeetingExpenseDetailsBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingExpenseDetailsTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[MeetingExpenseDetailsBaseTableViewCell class]] && [[(MeetingExpenseDetailsBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (MeetingExpenseDetailsBaseTableViewCell*)nibItem;
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
            auxIdentifier = self.iurTableCellId;
            break;
        case 2:
            auxIdentifier = self.dateTableCellId;
            break;
        case 3:
            auxIdentifier = self.textTableCellId;
            break;
        case 4:
            auxIdentifier = self.decimalTableCellId;
            break;
            
        default:
            auxIdentifier = self.textTableCellId;
            break;
    }
    return auxIdentifier;
}

@end
