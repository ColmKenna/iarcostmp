//
//  EmailRecipientTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 18/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EmailRecipientTableCell : UITableViewCell {
    UIImageView* _myImageView;
    UILabel* _myTextLabel;
}

@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* myTextLabel;

- (void)configImageView;

@end
