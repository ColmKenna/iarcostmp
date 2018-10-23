//
//  UtilitiesMasterTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 16/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UtilitiesMasterTableCell : UITableViewCell {
    UIImageView* _myImageView;
    UILabel* _titleLabel;
    UILabel* _subTitleLabel;
}

@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* subTitleLabel;

-(void)configCellWithData:(NSMutableDictionary*)theData;

@end
