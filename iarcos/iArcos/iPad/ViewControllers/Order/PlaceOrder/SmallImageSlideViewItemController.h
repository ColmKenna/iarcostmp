//
//  SmallImageSlideViewItemController.h
//  Arcos
//
//  Created by David Kilmartin on 14/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SmallImageSlideViewItemDelegate <NSObject>

- (void)didSelectSmallImageSlideViewItem:(int)anIndexPathRow;

@end


@interface SmallImageSlideViewItemController : UIViewController {
    int _indexPathRow;
    id<SmallImageSlideViewItemDelegate> _delegate;
    UIButton* _myButton;
    UILabel* _myLabel;
}

@property(nonatomic, assign) int indexPathRow;
@property(nonatomic, retain) id<SmallImageSlideViewItemDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* myButton;
@property(nonatomic, retain) IBOutlet UILabel* myLabel;

- (IBAction)pressButton:(id)sender;
- (void)clearContent;

@end
