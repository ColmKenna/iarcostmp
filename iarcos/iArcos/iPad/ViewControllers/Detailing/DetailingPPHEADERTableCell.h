//
//  DetailingPPHEADERTableCell.h
//  iArcos
//
//  Created by Richard on 03/03/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTableCell.h"



@interface DetailingPPHEADERTableCell : DetailingTableCell {
    UILabel* _descLabel;
    UIButton* _shownActiveButton;
}

@property(nonatomic, retain) IBOutlet UILabel* descLabel;
@property(nonatomic, retain) IBOutlet UIButton* shownActiveButton;

@end


