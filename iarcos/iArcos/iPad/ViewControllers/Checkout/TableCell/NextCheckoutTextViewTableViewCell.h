//
//  NextCheckoutTextViewTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutBaseTableViewCell.h"
#import "BorderedUITextView.h"

@interface NextCheckoutTextViewTableViewCell : NextCheckoutBaseTableViewCell {
    BorderedUITextView* _fieldValueTextView;
}

@property(nonatomic, retain) IBOutlet BorderedUITextView* fieldValueTextView;

@end
