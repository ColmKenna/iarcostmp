//
//  DetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell.h
//  iArcos
//
//  Created by Richard on 16/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"


@interface DetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell : DetailingCalendarEventBoxListingBaseTableCell {
    UIButton* _myImageButton;
    UILabel* _locationNameLabel;
    UILabel* _addressLabel;
}

@property (nonatomic,retain) IBOutlet UIButton* myImageButton;
@property (nonatomic,retain) IBOutlet UILabel* locationNameLabel;
@property (nonatomic,retain) IBOutlet UILabel* addressLabel;

@end

