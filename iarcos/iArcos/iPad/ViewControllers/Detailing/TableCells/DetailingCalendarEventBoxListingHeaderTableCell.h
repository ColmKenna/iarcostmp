//
//  DetailingCalendarEventBoxListingHeaderTableCell.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"


@interface DetailingCalendarEventBoxListingHeaderTableCell : DetailingCalendarEventBoxListingBaseTableCell {
    UILabel* _fieldDescLabel;
    UILabel* _dividerLabel;
}

@property (nonatomic,retain) IBOutlet UILabel* fieldDescLabel;
@property (nonatomic,retain) IBOutlet UILabel* dividerLabel;

@end


