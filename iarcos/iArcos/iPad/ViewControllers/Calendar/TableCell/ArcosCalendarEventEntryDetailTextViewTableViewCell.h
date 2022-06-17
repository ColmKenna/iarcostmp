//
//  ArcosCalendarEventEntryDetailTextViewTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"


@interface ArcosCalendarEventEntryDetailTextViewTableViewCell : ArcosCalendarEventEntryDetailBaseTableViewCell <UITextViewDelegate> {
    UITextView* _fieldValueTextView;
}

@property(nonatomic, retain) IBOutlet UITextView* fieldValueTextView;

@end


