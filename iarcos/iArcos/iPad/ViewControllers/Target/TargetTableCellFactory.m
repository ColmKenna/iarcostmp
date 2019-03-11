//
//  TargetTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetTableCellFactory.h"

@interface TargetTableCellFactory ()

- (TargetBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier;

@end

@implementation TargetTableCellFactory
@synthesize monthTableCellId = _monthTableCellId;
@synthesize yearTableCellId = _yearTableCellId;
@synthesize g1TableCellId = _g1TableCellId;

- (instancetype)init {
    if(self = [super init]) {
        self.monthTableCellId = @"IdTargetMonthTableViewCell";
        self.yearTableCellId = @"IdTargetYearTableViewCell";
        self.g1TableCellId = @"IdTargetG1TableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.monthTableCellId = nil;
    self.yearTableCellId = nil;
    self.g1TableCellId = nil;
    
    [super dealloc];
}

- (TargetBaseTableViewCell*)createTargetBaseTableCellWithData:(NSMutableDictionary*)aData {
    NSString* auxIdentifier = [self identifierWithData:aData];
    return [self getCellWithIdentifier:auxIdentifier];
}

- (TargetBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdentifier {
    TargetBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"TargetTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[TargetBaseTableViewCell class]] && [[(TargetBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdentifier]) {
            cell = (TargetBaseTableViewCell*) nibItem;  
            break;
        }
    }    
    return cell;
}

-(NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* identifier = nil;
    switch ([cellType intValue]) {
        case 0:
            identifier = self.monthTableCellId;
            break;
        case 1:
            identifier = self.yearTableCellId;
            break;
        case 3:
            identifier = self.g1TableCellId;
            break;
            
        default:
            identifier = self.monthTableCellId;
            break;
    }
    return identifier;
}

@end
