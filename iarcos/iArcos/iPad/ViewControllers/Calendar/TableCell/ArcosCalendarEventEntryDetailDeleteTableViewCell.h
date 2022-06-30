//
//  ArcosCalendarEventEntryDetailDeleteTableViewCell.h
//  iArcos
//
//  Created by Richard on 22/06/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"


@interface ArcosCalendarEventEntryDetailDeleteTableViewCell : ArcosCalendarEventEntryDetailBaseTableViewCell {
    UILabel* _fieldDescLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldDescLabel;

@end


