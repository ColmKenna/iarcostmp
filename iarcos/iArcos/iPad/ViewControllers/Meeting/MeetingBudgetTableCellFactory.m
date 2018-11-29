//
//  MeetingBudgetTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBudgetTableCellFactory.h"

@implementation MeetingBudgetTableCellFactory
@synthesize integerTableCellId = _integerTableCellId;
@synthesize decimalTableCellId = _decimalTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.integerTableCellId = @"IdMeetingBudgetIntegerTableViewCell";
        self.decimalTableCellId = @"IdMeetingBudgetDecimalTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.integerTableCellId = nil;
    self.decimalTableCellId = nil;
    
    [super dealloc];
}

- (MeetingBudgetBaseTableViewCell*)createMeetingBudgetBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

- (MeetingBudgetBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    MeetingBudgetBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingBudgetTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[MeetingBudgetBaseTableViewCell class]] && [[(MeetingBudgetBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (MeetingBudgetBaseTableViewCell*)nibItem;
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
            auxIdentifier = self.integerTableCellId;
            break;
        case 2:
            auxIdentifier = self.decimalTableCellId;
            break;
            
        default:
            auxIdentifier = self.integerTableCellId;
            break;
    }
    return auxIdentifier;
}

@end
