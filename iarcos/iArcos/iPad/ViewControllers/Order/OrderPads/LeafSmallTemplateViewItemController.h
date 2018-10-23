//
//  LeafSmallTemplateViewItemController.h
//  Arcos
//
//  Created by David Kilmartin on 21/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"
#import "ArcosUtils.h"
@protocol LeafSmallTemplateViewItemDelegate;

@interface LeafSmallTemplateViewItemController : UIViewController {
    id<LeafSmallTemplateViewItemDelegate> _delegate;
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    UIButton* btn4;
    UIButton* btn5;
    UIButton* btn6;
    
    UILabel* label1;
    UILabel* label2;    
    UILabel* label3;
    UILabel* label4;
    UILabel* label5;
    UILabel* label6;
        
    
    NSMutableArray* _btnList;
    NSMutableArray* _labelList;
    
//    LeftBorderUILabel* labelDividerBefore1;
//    LeftBorderUILabel* labelDividerAfter1;
//    LeftBorderUILabel* labelDividerAfter2;
//    LeftBorderUILabel* labelDividerAfter3;
//    LeftBorderUILabel* labelDividerAfter4;
//    LeftBorderUILabel* labelDividerAfter5;
        
    
    int _indexPathRow;
    int _itemPerPage;
    int _separatorWidth;
}

@property(nonatomic, assign) id<LeafSmallTemplateViewItemDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet UIButton* btn4;
@property(nonatomic, retain) IBOutlet UIButton* btn5;
@property(nonatomic, retain) IBOutlet UIButton* btn6;

@property(nonatomic, retain) IBOutlet UILabel* label1;
@property(nonatomic, retain) IBOutlet UILabel* label2;
@property(nonatomic, retain) IBOutlet UILabel* label3;
@property(nonatomic, retain) IBOutlet UILabel* label4;
@property(nonatomic, retain) IBOutlet UILabel* label5;
@property(nonatomic, retain) IBOutlet UILabel* label6;

@property(nonatomic, retain) NSMutableArray* btnList;
@property(nonatomic, retain) NSMutableArray* labelList;

//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerBefore1;
//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter1;
//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter2;
//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter3;
//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter4;
//@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter5;


@property(nonatomic, assign) int indexPathRow;
@property(nonatomic, assign) int itemPerPage;
@property(nonatomic, assign) int separatorWidth;

- (void)createPopulatedLists;
- (void)clearAllInfo;
- (void)getCellReadyToUse;
- (IBAction)pressButton:(id)sender;
- (void)alignSubviews;

@end

@protocol LeafSmallTemplateViewItemDelegate
-(void)didSelectSmallTemplateViewItemWithButton:(UIButton*)aBtn indexPathRow:(int)anIndexPathRow;
@end
