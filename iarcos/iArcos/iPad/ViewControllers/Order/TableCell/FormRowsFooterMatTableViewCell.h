//
//  FormRowsFooterMatTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"

@interface FormRowsFooterMatTableViewCell : UITableViewCell {
    UILabel* _titleLabel;
    UIView* _templateView;
    UILabel* _separatorLabel;
    UILabel* _qtyLabel0;
    UILabel* _qtyLabel1;
    UILabel* _qtyLabel2;
    UILabel* _qtyLabel3;
    UILabel* _qtyLabel4;
    UILabel* _qtyLabel5;
    UILabel* _qtyLabel6;
    UILabel* _qtyLabel7;
    UILabel* _qtyLabel8;
    UILabel* _qtyLabel9;
    UILabel* _qtyLabel10;
    UILabel* _qtyLabel11;
    
    UILabel* _bonLabel0;
    UILabel* _bonLabel1;
    UILabel* _bonLabel2;
    UILabel* _bonLabel3;
    UILabel* _bonLabel4;
    UILabel* _bonLabel5;
    UILabel* _bonLabel6;
    UILabel* _bonLabel7;
    UILabel* _bonLabel8;
    UILabel* _bonLabel9;
    UILabel* _bonLabel10;
    UILabel* _bonLabel11;
}

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UILabel* separatorLabel;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel0;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel1;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel2;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel3;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel4;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel5;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel6;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel7;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel8;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel9;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel10;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel11;

@property(nonatomic, retain) IBOutlet UILabel* bonLabel0;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel1;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel2;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel3;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel4;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel5;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel6;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel7;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel8;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel9;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel10;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel11;

- (void)configCellWithData:(NSMutableDictionary*)aDataDict matDataFoundFlag:(BOOL)aMatDataFoundFlag;

@end

