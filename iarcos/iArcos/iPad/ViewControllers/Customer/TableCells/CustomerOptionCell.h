//
//  CusomerOptionCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomerOptionCellDelegate
-(void)AddButtonPressed:(NSInteger)index;
@end

@interface CustomerOptionCell : UITableViewCell{
    IBOutlet UIImageView* optionIcon;
    IBOutlet UILabel* optionTitle;
    IBOutlet UIButton* optionAddBut;
    IBOutlet UILabel* optionDetail;
    
    id <CustomerOptionCellDelegate> delegate;
}
@property(nonatomic,retain) IBOutlet UIImageView* optionIcon;
@property(nonatomic,retain) IBOutlet UILabel* optionTitle;
@property(nonatomic,retain) IBOutlet UIButton* optionAddBut;
@property(nonatomic,assign)  id <CustomerOptionCellDelegate> delegate;
@property(nonatomic,retain)  IBOutlet UILabel* optionDetail;

-(IBAction)AddButtonAction:(id)sender;
@end
