//
//  LargeImageSlideViewItemController.h
//  Arcos
//
//  Created by David Kilmartin on 11/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LargeImageSlideViewItemDelegate <NSObject>

- (void)didSelectLargeImageSlideViewItem:(int)anIndexPathRow;
@optional
- (void)didDoubleTapLargeImageSlideViewItem:(int)anIndexPathRow;

@end

@interface LargeImageSlideViewItemController : UIViewController {
    int _indexPathRow;
    id<LargeImageSlideViewItemDelegate> _delegate;
    UIButton* _myButton;
}

@property(nonatomic, assign) int indexPathRow;
@property(nonatomic, retain) id<LargeImageSlideViewItemDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* myButton;

- (IBAction)pressButton:(id)sender;
- (void)clearContent;

@end
