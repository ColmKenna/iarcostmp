//
//  DetailingPresenterTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 23/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailingTableCell.h"

@interface DetailingPresenterTableCell : DetailingTableCell {
    UILabel* _label;
    UILabel* _statusLabel;
}

@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* statusLabel;

@end
