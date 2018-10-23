//
//  CustomerGroupTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupTableCellFactory.h"
@interface CustomerGroupTableCellFactory()

- (CustomerGroupBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier;

@end

@implementation CustomerGroupTableCellFactory
@synthesize contactTableCellId = _contactTableCellId;
@synthesize accessTimesTableCellId = _accessTimesTableCellId;
@synthesize notSeenTableCellId = _notSeenTableCellId;
@synthesize buyingGroupTableCellId = _buyingGroupTableCellId;

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.contactTableCellId = @"IdCustomerGroupContactTableViewCell";
        self.accessTimesTableCellId = @"IdCustomerGroupAccessTimesTableViewCell";
        self.notSeenTableCellId = @"IdCustomerGroupNotSeenTableViewCell";
        self.buyingGroupTableCellId = @"IdCustomerGroupBuyingGroupTableViewCell";
    }
    return self;
}

+ (instancetype)factory {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.contactTableCellId = nil;
    self.accessTimesTableCellId = nil;
    self.notSeenTableCellId = nil;
    self.buyingGroupTableCellId = nil;
    
    [super dealloc];
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 0:
            identifier = self.contactTableCellId;
            break;
        case 1:
            identifier = self.accessTimesTableCellId;
            break;
        case 2:
            identifier = self.notSeenTableCellId;
            break;
        case 3:
            identifier = self.buyingGroupTableCellId;
            break;
            
        default:
            identifier = self.contactTableCellId;
            break;
    }
    return identifier;
}

- (CustomerGroupBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    CustomerGroupBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerGroupContactTableViewCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[CustomerGroupBaseTableViewCell class]] && [[(CustomerGroupBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (CustomerGroupBaseTableViewCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (CustomerGroupBaseTableViewCell*)createCustomerGroupBaseTableViewCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

@end
