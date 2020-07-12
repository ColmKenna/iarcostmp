//
//  CustomerTyvLyTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBorderUILabel.h"

@interface CustomerTyvLyTableCell : UITableViewCell {    
    LeftBorderUILabel* orderPadDetails;
    UILabel* productCode;
    UILabel* productSize;
    LeftBorderUILabel* details;
    
    LeftBorderUILabel* _inStock;
    
    LeftBorderUILabel* lYQty;
    LeftBorderUILabel* lYBonus;
    LeftBorderUILabel* lYValue;
    
    LeftBorderUILabel* lYTDQty;
    LeftBorderUILabel* lYTDBonus;
    LeftBorderUILabel* lYTDValue;
    
    LeftBorderUILabel* tYTDQty;
    LeftBorderUILabel* tYTDBonus;
    LeftBorderUILabel* tYTDValue;
        
    LeftBorderUILabel* qty;
    
}

 
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* orderPadDetails;
@property (nonatomic,retain) IBOutlet UILabel* productCode;
@property (nonatomic,retain) IBOutlet UILabel* productSize;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* details;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* inStock;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYQty;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYBonus;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYValue;

@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYTDQty;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYTDBonus;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* lYTDValue;

@property (nonatomic,retain) IBOutlet LeftBorderUILabel* tYTDQty;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* tYTDBonus;
@property (nonatomic,retain) IBOutlet LeftBorderUILabel* tYTDValue;

@property (nonatomic,retain) IBOutlet LeftBorderUILabel* qty;


@end
