//
//  LeafSmallTemplatePageIndexViewController.h
//  Arcos
//
//  Created by David Kilmartin on 04/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeafSmallTemplatePageIndexControlView.h"
@protocol LeafSmallTemplatePageIndexDelegate;


@interface LeafSmallTemplatePageIndexViewController : UIViewController {
    id<LeafSmallTemplatePageIndexDelegate> _pageIndexDelegate;
    NSMutableArray* _displayList;
    float _pageIndexViewWidth;
    NSMutableArray* _labelList;
    float _separateHeight;
    float _cellHeight;
    float _usedCellHeight;
    float _labelHeight;
}

@property(nonatomic, assign) id<LeafSmallTemplatePageIndexDelegate> pageIndexDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) float pageIndexViewWidth;
@property(nonatomic, retain) NSMutableArray* labelList;
@property(nonatomic, assign) float separateHeight;
@property(nonatomic, assign) float cellHeight;
@property(nonatomic, assign) float usedCellHeight;
@property(nonatomic, assign) float labelHeight;

- (IBAction)indexViewTouchUpInside:(id)sender;
- (IBAction)indexViewTouchUpOutside:(id)sender;

@end

@protocol LeafSmallTemplatePageIndexDelegate <NSObject>

- (void)pressPageIndexWithLabel:(UILabel*)anLabel;

@end
