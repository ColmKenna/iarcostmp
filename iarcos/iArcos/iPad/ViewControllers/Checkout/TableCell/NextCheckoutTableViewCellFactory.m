//
//  NextCheckoutTableViewCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutTableViewCellFactory.h"
@interface NextCheckoutTableViewCellFactory ()

- (NextCheckoutBaseTableViewCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation NextCheckoutTableViewCellFactory
@synthesize dateLabelTableCellId = _dateLabelTableCellId;
@synthesize readOnlyLabelTableCellId = _readOnlyLabelTableCellId;
@synthesize writableLabelTableCellId = _writableLabelTableCellId;
@synthesize contactLabelTableCellId = _contactLabelTableCellId;
@synthesize accountLabelTableCellId = _accountLabelTableCellId;
@synthesize employeeLabelTableCellId = _employeeLabelTableCellId;
@synthesize textFieldTableCellId = _textFieldTableCellId;
@synthesize textViewTableCellId = _textViewTableCellId;
@synthesize followUpTextViewTableCellId = _followUpTextViewTableCellId;
@synthesize followUpEmployeeTableCellId = _followUpEmployeeTableCellId;
@synthesize followUpWritableLabelTableCellId = _followUpWritableLabelTableCellId;
@synthesize followUpDateLabelTableCellId = _followUpDateLabelTableCellId;
@synthesize deliveryInstructions1TableCellId = _deliveryInstructions1TableCellId;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.dateLabelTableCellId = @"IdNextCheckoutDateTableViewCell";
        self.readOnlyLabelTableCellId = @"IdNextCheckoutReadOnlyTableViewCell";
        self.writableLabelTableCellId = @"IdNextCheckoutWritableTableViewCell";
        self.contactLabelTableCellId = @"IdNextCheckoutContactTableViewCell";
        self.accountLabelTableCellId = @"IdNextCheckoutAccountTableViewCell";
        self.employeeLabelTableCellId = @"IdNextCheckoutEmployeeTableViewCell";
        self.textFieldTableCellId = @"IdNextCheckoutTextFieldTableViewCell";
        self.textViewTableCellId = @"IdNextCheckoutTextViewTableViewCell";
        self.followUpTextViewTableCellId = @"IdNextCheckoutFollowUpTextViewTableViewCell";
        self.followUpEmployeeTableCellId = @"IdNextCheckoutFollowUpEmployeeTableViewCell";
        self.followUpWritableLabelTableCellId = @"IdNextCheckoutFollowUpWritableTableViewCell";
        self.followUpDateLabelTableCellId = @"IdNextCheckoutFollowUpDateTableViewCell";
        self.deliveryInstructions1TableCellId = @"IdNextCheckoutDeliveryInstructions1TableViewCell";
    }
    return self;
}

+ (id)factory{
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.dateLabelTableCellId = nil;
    self.readOnlyLabelTableCellId = nil;
    self.writableLabelTableCellId = nil;
    self.contactLabelTableCellId = nil;
    self.accountLabelTableCellId = nil;
    self.employeeLabelTableCellId = nil;
    self.textFieldTableCellId = nil;
    self.textViewTableCellId = nil;
    self.followUpTextViewTableCellId = nil;
    self.followUpEmployeeTableCellId = nil;
    self.followUpWritableLabelTableCellId = nil;
    self.followUpDateLabelTableCellId = nil;
    self.deliveryInstructions1TableCellId = nil;
    
    [super dealloc];
}

- (NextCheckoutBaseTableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    NextCheckoutBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"NextCheckoutTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[NextCheckoutBaseTableViewCell class]] && [[(NextCheckoutBaseTableViewCell *)nibItem reuseIdentifier] isEqualToString:idendifier]) {
            cell = (NextCheckoutBaseTableViewCell *)nibItem;
            break;
        }
    }
    return cell;
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 1:
            identifier = self.dateLabelTableCellId;
            break;
        case 2:
            identifier = self.readOnlyLabelTableCellId;
            break;
        case 3:
            identifier = self.writableLabelTableCellId;
            break;
        case 4:
            identifier = self.contactLabelTableCellId;
            break;
        case 5:
            identifier = self.accountLabelTableCellId;
            break;
        case 6:
            identifier = self.employeeLabelTableCellId;
            break;
        case 7:
            identifier = self.textFieldTableCellId;
            break;
        case 8:
            identifier = self.textViewTableCellId;
            break;
        case 9:
            identifier = self.followUpTextViewTableCellId;
            break;
        case 10:
            identifier = self.followUpEmployeeTableCellId;
            break;
        case 11:
            identifier = self.followUpWritableLabelTableCellId;
            break;
        case 12:
            identifier = self.followUpDateLabelTableCellId;
            break;
        case 13:
            identifier = self.deliveryInstructions1TableCellId;
            break;
            
        default:
            identifier = self.dateLabelTableCellId;
            break;
    }
    return identifier;
}

- (NextCheckoutBaseTableViewCell*)createNextCheckoutBaseTableViewCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

@end
