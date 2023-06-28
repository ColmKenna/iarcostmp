//
//  MeetingPresentersTableCellFactory.m
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersTableCellFactory.h"

@implementation MeetingPresentersTableCellFactory
@synthesize headerTableCellId = _headerTableCellId;
@synthesize presenterTableCellId = _presenterTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerTableCellId = @"IdMeetingPresentersHeaderTableViewCell";
        self.presenterTableCellId = @"IdMeetingPresentersTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.headerTableCellId = nil;
    self.presenterTableCellId = nil;
    
    [super dealloc];
}

- (NSString*)identifierWithData:(MeetingPresentersCompositeObject*)aData {
    NSString* auxIdentifier = nil;
    switch ([aData.cellType intValue]) {
        case 1:
            auxIdentifier = self.headerTableCellId;
            break;
        case 2:
            auxIdentifier = self.presenterTableCellId;
            break;
            
        default:
            auxIdentifier = self.headerTableCellId;
            break;
    }
    return auxIdentifier;
}

- (MeetingPresentersBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    MeetingPresentersBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingPresentersTableViewCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[MeetingPresentersBaseTableViewCell class]] && [[(MeetingPresentersBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (MeetingPresentersBaseTableViewCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (MeetingPresentersBaseTableViewCell*)createMeetingPresentersBaseTableCellWithData:(MeetingPresentersCompositeObject*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

@end
