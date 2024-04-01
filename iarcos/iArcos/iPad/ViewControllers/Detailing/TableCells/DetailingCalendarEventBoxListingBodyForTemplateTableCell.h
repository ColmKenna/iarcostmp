//
//  DetailingCalendarEventBoxListingBodyForTemplateTableCell.h
//  iArcos
//
//  Created by Richard on 29/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"


@interface DetailingCalendarEventBoxListingBodyForTemplateTableCell : DetailingCalendarEventBoxListingBaseTableCell {
    UILabel* _fieldDescLabel;
}

@property (nonatomic,retain) IBOutlet UILabel* fieldDescLabel;

@end


