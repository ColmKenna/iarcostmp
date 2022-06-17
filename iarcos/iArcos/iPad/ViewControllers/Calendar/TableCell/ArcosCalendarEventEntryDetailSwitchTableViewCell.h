//
//  ArcosCalendarEventEntryDetailSwitchTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"


@interface ArcosCalendarEventEntryDetailSwitchTableViewCell : ArcosCalendarEventEntryDetailBaseTableViewCell {
    UILabel* _fieldDescLabel;
    UISwitch* _fieldValueSwitch;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldDescLabel;
@property(nonatomic, retain) IBOutlet UISwitch* fieldValueSwitch;

- (IBAction)switchValueChange:(id)sender;

@end


