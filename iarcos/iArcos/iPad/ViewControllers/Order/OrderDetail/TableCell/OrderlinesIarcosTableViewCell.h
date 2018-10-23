//
//  OrderlinesIarcosTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderlinesIarcosTableViewCell : UITableViewCell {
    UILabel* _orderPadDetails;
    UILabel* _productCode;
    UILabel* _productSize;
    UILabel* _description;
    UILabel* _value;
    UIView* _normalQtyView;
    UILabel* _qtyInNormalQtyView;
}

@property (nonatomic,retain) IBOutlet UILabel* orderPadDetails;
@property (nonatomic,retain) IBOutlet UILabel* productCode;
@property (nonatomic,retain) IBOutlet UILabel* productSize;
@property (nonatomic,retain) IBOutlet UILabel* description;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) IBOutlet UIView* normalQtyView;
@property (nonatomic,retain) IBOutlet UILabel* qtyInNormalQtyView;


@end
