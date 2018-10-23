//
//  NextCheckoutFollowUpTextViewTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 31/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutBaseTableViewCell.h"
#import "BorderedUITextView.h"

@interface NextCheckoutFollowUpTextViewTableViewCell : NextCheckoutBaseTableViewCell {
    BorderedUITextView* _fieldValueTextView;
}

@property(nonatomic, retain) IBOutlet BorderedUITextView* fieldValueTextView;

@end
