//
//  PreviousOrderTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedableTableCell.h"

@interface PreviousOrderTableCell : UITableViewCell {
    IBOutlet UILabel* number;
    IBOutlet UILabel* date;
    IBOutlet UILabel* name;
    IBOutlet UILabel* address;
    IBOutlet UILabel* value;
    IBOutlet UILabel* point;
    IBOutlet UILabel* deliveryDate;

    IBOutlet UIImageView* selectIndicator;
    
    BOOL isSelected;
    
    NSObject* data;
    NSIndexPath* theIndexPath;

}

@property (nonatomic,retain) IBOutlet UILabel* number;
@property (nonatomic,retain) IBOutlet UILabel* date;
@property (nonatomic,retain) IBOutlet UILabel* name;
@property (nonatomic,retain) IBOutlet UILabel* address;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) IBOutlet UILabel* point;
@property (nonatomic,retain) IBOutlet UILabel* deliveryDate;
@property (nonatomic,retain) IBOutlet UIImageView* selectIndicator;
@property (nonatomic,retain)     NSObject* data;
@property (nonatomic,retain) NSIndexPath* theIndexPath;


-(void)flipSelectStatus;
-(void)setSelectStatus:(BOOL)select;
@end
