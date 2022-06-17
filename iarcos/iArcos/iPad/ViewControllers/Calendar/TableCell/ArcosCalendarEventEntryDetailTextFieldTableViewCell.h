//
//  ArcosCalendarEventEntryDetailTextFieldTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"



@interface ArcosCalendarEventEntryDetailTextFieldTableViewCell : ArcosCalendarEventEntryDetailBaseTableViewCell <UITextFieldDelegate> {
    UITextField* _fieldValueTextField;
    
}

@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end


