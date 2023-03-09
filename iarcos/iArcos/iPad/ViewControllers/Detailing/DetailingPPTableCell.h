//
//  DetailingPPTableCell.h
//  iArcos
//
//  Created by Richard on 03/03/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTableCell.h"

@interface DetailingPPTableCell : DetailingTableCell {
    UIImageView* _myImageView;
    UILabel* _fullTitleLabel;
    UILabel* _memoDetailsLabel;
    UIButton* _shownButton;
    UIButton* _shownActiveButton;
}

@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* fullTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* memoDetailsLabel;
@property(nonatomic, retain) IBOutlet UIButton* shownButton;
@property(nonatomic, retain) IBOutlet UIButton* shownActiveButton;

- (IBAction)shownButtonPressed:(id)sender;
- (IBAction)shownActiveButtonPressed:(id)sender;


@end


