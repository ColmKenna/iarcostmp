//
//  MainPresenterTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPresenterTableViewCellDelegate.h"
#import "LeftRightInsetUILabel.h"
#import "LeftBorderUIView.h"
#import "LeftBorderUILabel.h"

@interface MainPresenterTableViewCell : UITableViewCell {
    id<MainPresenterTableViewCellDelegate> _myDelegate;
    NSIndexPath* _indexPath;
    UIView* view1;
    LeftBorderUIView* view2;
    LeftBorderUIView* view3;
    LeftBorderUIView* view4;
    LeftBorderUIView* view5;
    
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    UIButton* btn4;
    UIButton* btn5;
    
    LeftRightInsetUILabel* label1;
    LeftBorderUILabel* label2;
    LeftBorderUILabel* label3;
    LeftBorderUILabel* label4;
    LeftBorderUILabel* label5;
    
    NSMutableArray* _viewList;
    NSMutableArray* _btnList;
    NSMutableArray* _labelList;
}

@property(nonatomic, assign) id<MainPresenterTableViewCellDelegate> myDelegate;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, retain) IBOutlet UIView* view1;
@property(nonatomic, retain) IBOutlet LeftBorderUIView* view2;
@property(nonatomic, retain) IBOutlet LeftBorderUIView* view3;
@property(nonatomic, retain) IBOutlet LeftBorderUIView* view4;
@property(nonatomic, retain) IBOutlet LeftBorderUIView* view5;
@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet UIButton* btn4;
@property(nonatomic, retain) IBOutlet UIButton* btn5;

@property(nonatomic, retain) IBOutlet LeftRightInsetUILabel* label1;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* label2;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* label3;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* label4;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* label5;

@property(nonatomic, retain) NSMutableArray* viewList;
@property(nonatomic, retain) NSMutableArray* btnList;
@property(nonatomic, retain) NSMutableArray* labelList;

- (void)handleSingleTapGesture:(id)sender;
- (void)createPopulatedLists;
- (void)clearAllInfo;
- (void)addEventToView;
- (void)makeCellReadyToUse;

@end
