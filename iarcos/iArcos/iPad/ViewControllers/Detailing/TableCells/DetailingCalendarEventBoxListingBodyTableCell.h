//
//  DetailingCalendarEventBoxListingBodyTableCell.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"


@interface DetailingCalendarEventBoxListingBodyTableCell : DetailingCalendarEventBoxListingBaseTableCell {
    UILabel* _fieldDescLabel;
}

@property (nonatomic,retain) IBOutlet UILabel* fieldDescLabel;

@end

