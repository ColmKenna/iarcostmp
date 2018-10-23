//
//  ReportMeetingTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 17/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportCell.h"
#import "ArcosUtils.h"

@interface ReportMeetingTableViewCell : ReportCell {
    UILabel* _reasonLabel;
    UILabel* _venueLabel;
    UILabel* _typeLabel;
    UILabel* _statusLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* reasonLabel;
@property(nonatomic, retain) IBOutlet UILabel* venueLabel;
@property(nonatomic, retain) IBOutlet UILabel* typeLabel;
@property(nonatomic, retain) IBOutlet UILabel* statusLabel;

@end
