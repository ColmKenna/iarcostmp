//
//  OrderProductTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedableTableCell.h"
#import "OrderProductTableCellDelegate.h"
#import "ArcosCoreData.h"
#import <QuartzCore/QuartzCore.h>
#import "ArcosConfigDataManager.h"

@interface OrderProductTableCell : UITableViewCell {
    UIImageView* _productImageView;
    IBOutlet UILabel* description;
    UILabel* _rrpPrice;
    IBOutlet UILabel* price;
    IBOutlet UILabel* qty;
    IBOutlet UILabel* value;
    IBOutlet UILabel* discount;
    IBOutlet UILabel* bonus;
    IBOutlet UIButton* editButton;
    
    IBOutlet UIImageView* selectIndicator;
    
    BOOL isSelected;
    
    NSObject* data;
    NSIndexPath* theIndexPath;
    IBOutlet UILabel* InStock;
    IBOutlet UILabel* FOC;
    UILabel* orderPadDetails;
    UILabel* productCode;
    UILabel* productSize;
    id<OrderProductTableCellDelegate> _cellDelegate;
    NSMutableDictionary* _cellData;
//    UILabel* _uniLabel;
//    UILabel* _udLabel;
    UILabel* _maxLabel;
    UILabel* _prevLabel;
    UILabel* _prevNormalLabel;
}

@property (nonatomic,retain) IBOutlet UIImageView* productImageView;
@property (nonatomic,retain) IBOutlet UILabel* description;
@property (nonatomic,retain) IBOutlet UILabel* rrpPrice;
@property (nonatomic,retain) IBOutlet UILabel* price;
@property (nonatomic,retain) IBOutlet UILabel* qty;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) IBOutlet UILabel* discount;
@property (nonatomic,retain) IBOutlet UILabel* bonus;
@property (nonatomic,retain) IBOutlet UIButton* editButton;
@property (nonatomic,retain) NSIndexPath* theIndexPath;
@property (nonatomic,retain) IBOutlet UILabel* InStock;
@property (nonatomic,retain) IBOutlet UILabel* FOC;
@property (nonatomic,retain) IBOutlet UILabel* orderPadDetails;
@property (nonatomic,retain) IBOutlet UILabel* productCode;
@property (nonatomic,retain) IBOutlet UILabel* productSize;
@property (nonatomic,assign) id<OrderProductTableCellDelegate> cellDelegate;
@property (nonatomic,retain) NSMutableDictionary* cellData;
//@property (nonatomic,retain) IBOutlet UILabel* uniLabel;
//@property (nonatomic,retain) IBOutlet UILabel* udLabel;
@property (nonatomic,retain) IBOutlet UILabel* maxLabel;
@property (nonatomic,retain) IBOutlet UILabel* prevLabel;
@property (nonatomic,retain) IBOutlet UILabel* prevNormalLabel;

-(void)needEditButton:(BOOL)need;

@property (nonatomic,retain) IBOutlet UIImageView* selectIndicator;
@property (nonatomic,retain)     NSObject* data;


-(void)flipSelectStatus;
-(void)setSelectStatus:(BOOL)select;
-(void)configCellWithData:(NSMutableDictionary*)theData;
- (void)configBackgroundColour:(BOOL)select;
- (void)configMatImageWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR;
- (void)configPreviousWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR previousNumber:(NSNumber*)aPreviousNumber prevFlag:(BOOL)aPrevFlag prevLabel:(UILabel*)aPrevLable;

@end
