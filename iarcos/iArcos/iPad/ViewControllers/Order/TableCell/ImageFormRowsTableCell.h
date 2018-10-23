//
//  ImageFormRowsTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 22/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"
@protocol ImageFormRowsDelegate;

@interface ImageFormRowsTableCell : UITableViewCell {
    id<ImageFormRowsDelegate> _delegate;
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    UIButton* btn4;
    UIButton* btn5;
    
    UILabel* label1;
    UILabel* label2;    
    UILabel* label3;
    UILabel* label4;
    UILabel* label5;            
    
    NSMutableArray* _btnList;
    NSMutableArray* _labelList;
    NSIndexPath* _indexPath;
    
    LeftBorderUILabel* labelDividerAfter1;
    LeftBorderUILabel* labelDividerAfter2;
    LeftBorderUILabel* labelDividerAfter3;
    LeftBorderUILabel* labelDividerAfter4;
}

@property(nonatomic, assign) id<ImageFormRowsDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet UIButton* btn4;
@property(nonatomic, retain) IBOutlet UIButton* btn5;

@property(nonatomic, retain) IBOutlet UILabel* label1;
@property(nonatomic, retain) IBOutlet UILabel* label2;
@property(nonatomic, retain) IBOutlet UILabel* label3;
@property(nonatomic, retain) IBOutlet UILabel* label4;
@property(nonatomic, retain) IBOutlet UILabel* label5;


@property(nonatomic, retain) NSMutableArray* btnList;
@property(nonatomic, retain) NSMutableArray* labelList;
@property(nonatomic, retain) NSIndexPath* indexPath;

@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter1;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter2;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter3;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* labelDividerAfter4;


- (void)createPopulatedLists;
- (IBAction)pressButton:(id)sender;
- (void)disableAllButtons;
- (void)clearAllInfo;
- (void)getCellReadyToUse;

@end

@protocol ImageFormRowsDelegate
-(void)imageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath;
@end
