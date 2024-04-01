//
//  DetailingCalendarEventBoxListingTableCellFactory.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailingCalendarEventBoxListingBaseTableCell.h"

@interface DetailingCalendarEventBoxListingTableCellFactory : NSObject {
    NSString* _detailingCalendarEventBoxListingHeaderTableCellId;
    NSString* _detailingCalendarEventBoxListingBodyTableCellId;
    NSString* _detailingCalendarEventBoxListingPlaceHolderTableCellId;
    NSString* _detailingCalendarEventBoxListingBodyForTemplateTableCellId;
}

@property (nonatomic, retain) NSString* detailingCalendarEventBoxListingHeaderTableCellId;
@property (nonatomic, retain) NSString* detailingCalendarEventBoxListingBodyTableCellId;
@property (nonatomic, retain) NSString* detailingCalendarEventBoxListingPlaceHolderTableCellId;
@property (nonatomic, retain) NSString* detailingCalendarEventBoxListingBodyForTemplateTableCellId;

- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (DetailingCalendarEventBoxListingBaseTableCell*)createDetailingCalendarEventBoxListingBaseTableCellWithData:(NSMutableDictionary*)aData;

@end


