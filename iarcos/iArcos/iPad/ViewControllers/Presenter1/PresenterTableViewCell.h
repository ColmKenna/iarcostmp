//
//  PresenterTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PresenterTableViewCell : UITableViewCell {
//    IBOutlet UIImageView* mainImage;
    IBOutlet UITextView* title;
    IBOutlet UITextView* description;
    IBOutlet UILabel* extraDesc;
    IBOutlet UIImageView* bgImageView;
    UIImageView* promotionView;
    
    UIImageView* _subBgImage;
    UIImageView* _dividerImage;
    UIButton* _mainButton;
}
//@property(nonatomic,retain) IBOutlet UIImageView* mainImage;
@property(nonatomic,retain) IBOutlet UITextView* title;
@property(nonatomic,retain) IBOutlet UITextView* description;
@property(nonatomic,retain) IBOutlet UILabel* extraDesc;
@property(nonatomic,retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic,retain) IBOutlet UIImageView* promotionView;

@property(nonatomic,retain) IBOutlet UIImageView* subBgImage;
@property(nonatomic,retain) IBOutlet UIImageView* dividerImage;
@property(nonatomic,retain) IBOutlet UIButton* mainButton;

@end
