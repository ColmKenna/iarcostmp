//
//  DetailingTreeLeafTableCell.h
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTreeBaseTableCell.h"


@interface DetailingTreeLeafTableCell : DetailingTreeBaseTableCell {
    UIButton* _flagBtn;
}

@property(nonatomic, retain) IBOutlet UIButton* flagBtn;

@end


