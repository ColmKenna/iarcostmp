//
//  DetailingCalendarEventBoxListingBodyForPopOutTableCell.h
//  iArcos
//
//  Created by Richard on 21/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"


@interface DetailingCalendarEventBoxListingBodyForPopOutTableCell : DetailingCalendarEventBoxListingBaseTableCell {
    UILabel* _fieldDescLabel;
    UIView* _bgView;
    UILabel* _titleLabel;
    UILabel* _locationLabel;
}

@property (nonatomic,retain) IBOutlet UILabel* fieldDescLabel;
@property (nonatomic,retain) IBOutlet UIView* bgView;
@property (nonatomic,retain) IBOutlet UILabel* titleLabel;
@property (nonatomic,retain) IBOutlet UILabel* locationLabel;

@end

