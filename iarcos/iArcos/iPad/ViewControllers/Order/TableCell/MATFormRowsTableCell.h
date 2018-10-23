//
//  MATFormRowsTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 26/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LeftBorderUILabel.h"

@interface MATFormRowsTableCell : UITableViewCell {
/*
    UITextField* details;
    
    UITextField* field3;
    UITextField* field4;  
    UITextField* field5;
    UITextField* field6;
    UITextField* field7;
    UITextField* field8;
    UITextField* field9;
    UITextField* field10;
    UITextField* field11;
    UITextField* field12;
    UITextField* field13;
    UITextField* field14;
    UITextField* field15;
    UITextField* field16;
    UITextField* qty;
    UITextField* bon;
*/ 
    NSMutableDictionary* _cellFormRowData;
    NSIndexPath* _indexPath;    
//    UIImageView* selectIndicator;
//    UITextField* selectedIndicator;
    BOOL isSelected;
    
    UILabel* labelSelectedIndicator;
    LeftBorderUILabel* labelDividerBeforeDetails;
    UILabel* orderPadDetails;
    UILabel* productCode;
    UILabel* productSize;
    UILabel* labelDetails;
    LeftBorderUILabel* label3;
    LeftBorderUILabel* label4;
    LeftBorderUILabel* label5;
    LeftBorderUILabel* label6;
    LeftBorderUILabel* label7;
    LeftBorderUILabel* label8;
    LeftBorderUILabel* label9;
    LeftBorderUILabel* label10;
    LeftBorderUILabel* label11;
    LeftBorderUILabel* label12;
    LeftBorderUILabel* label13;
    LeftBorderUILabel* label14;
    LeftBorderUILabel* label15;
    LeftBorderUILabel* labelDividerAfter15;
    LeftBorderUILabel* label16;
    LeftBorderUILabel* labelDividerAfter16;
    LeftBorderUILabel* labelQty;
//    LeftBorderUILabel* labelDividerAfterQty;
    LeftBorderUILabel* labelBon;
    LeftBorderUILabel* labelStock;
    LeftBorderUILabel* labelSRP;
    LeftBorderUILabel* labelPrice;
}

/*
@property (nonatomic,retain) IBOutlet UITextField* details;
@property (nonatomic,retain) IBOutlet UITextField* field3;
@property (nonatomic,retain) IBOutlet UITextField* field4;  
@property (nonatomic,retain) IBOutlet UITextField* field5;
@property (nonatomic,retain) IBOutlet UITextField* field6;
@property (nonatomic,retain) IBOutlet UITextField* field7;
@property (nonatomic,retain) IBOutlet UITextField* field8;
@property (nonatomic,retain) IBOutlet UITextField* field9;
@property (nonatomic,retain) IBOutlet UITextField* field10;
@property (nonatomic,retain) IBOutlet UITextField* field11;
@property (nonatomic,retain) IBOutlet UITextField* field12;
@property (nonatomic,retain) IBOutlet UITextField* field13;
@property (nonatomic,retain) IBOutlet UITextField* field14;
@property (nonatomic,retain) IBOutlet UITextField* field15;
@property (nonatomic,retain) IBOutlet UITextField* field16;
@property (nonatomic,retain) IBOutlet UITextField* qty;
@property (nonatomic,retain) IBOutlet UITextField* bon;
*/
@property (nonatomic,retain) NSMutableDictionary* cellFormRowData;
@property(nonatomic,retain) NSIndexPath* indexPath;
//@property(nonatomic,retain) IBOutlet UIImageView* selectIndicator;
//@property(nonatomic,retain) IBOutlet UITextField* selectedIndicator;

@property (nonatomic,retain) IBOutlet UILabel* labelSelectedIndicator;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelDividerBeforeDetails;
@property (nonatomic,retain) IBOutlet UILabel* orderPadDetails;
@property (nonatomic,retain) IBOutlet UILabel* productCode;
@property (nonatomic,retain) IBOutlet UILabel* productSize;
@property (nonatomic,retain) IBOutlet UILabel* labelDetails;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label3;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label4;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label5;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label6;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label7;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label8;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label9;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label10;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label11;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label12;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label13;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label14;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label15;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelDividerAfter15;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* label16;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelDividerAfter16;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelQty;
//@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelDividerAfterQty;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelBon;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelStock;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelSRP;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* labelPrice;


-(void)initIndicatorBorder;
-(void)setSelectStatus:(BOOL)select;
-(void)setCellSelectStatus:(BOOL)select;

@end
