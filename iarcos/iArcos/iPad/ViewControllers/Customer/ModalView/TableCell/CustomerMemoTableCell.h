//
//  CustomerMemoTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerMemoInputDelegate.h"

@interface CustomerMemoTableCell : UITableViewCell<UITextViewDelegate> {    
    IBOutlet UILabel* date;
    IBOutlet UILabel* employee;
    IBOutlet UILabel* contact;
    IBOutlet UITextView* memo;
    IBOutlet UIImageView* bgImageView;
    UIImageView* _subBgImageView;
    IBOutlet UIImageView* dateImageView;
    IBOutlet UIImageView* verticalImageView;    
    IBOutlet UIImageView* horizontalImageView;    
    IBOutlet UILabel* memoType;
    NSIndexPath* indexPath;
    id<CustomerMemoInputDelegate> delegate;
}

@property(nonatomic,retain) IBOutlet UILabel* date;
@property(nonatomic,retain) IBOutlet UILabel* employee;
@property(nonatomic,retain) IBOutlet UILabel* contact;
@property(nonatomic,retain) IBOutlet UITextView* memo;
@property(nonatomic,retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic,retain) IBOutlet UIImageView* subBgImageView;
@property(nonatomic,retain) IBOutlet UIImageView* dateImageView;
@property(nonatomic,retain) IBOutlet UIImageView* verticalImageView;
@property(nonatomic,retain) IBOutlet UIImageView* horizontalImageView;
@property(nonatomic,retain) IBOutlet UILabel* memoType;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) id<CustomerMemoInputDelegate> delegate;

-(void)configCellWithIndexPath:(NSIndexPath*) anIndexPath;

@end
