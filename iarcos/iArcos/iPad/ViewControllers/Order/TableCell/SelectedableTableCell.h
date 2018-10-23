//
//  SelectedableTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectedableTableCell : UITableViewCell {
    IBOutlet UIImageView* selectIndicator;
    
    BOOL isSelected;
    
    NSObject* data;
}
@property (nonatomic,retain) IBOutlet UIImageView* selectIndicator;
@property (nonatomic,assign)     NSObject* data;


-(void)flipSelectStatus;
-(void)setSelectStatus:(BOOL)select;
@end
