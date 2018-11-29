//
//  MeetingTextViewTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"


@interface MeetingTextViewTableViewCell : MeetingBaseTableViewCell <UITextViewDelegate> {
    UILabel* _fieldNameLabel;
    UITextView* _fieldValueTextView;
    BOOL _styleSetFlag;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextView* fieldValueTextView;
@property(nonatomic, assign) BOOL styleSetFlag;

@end

