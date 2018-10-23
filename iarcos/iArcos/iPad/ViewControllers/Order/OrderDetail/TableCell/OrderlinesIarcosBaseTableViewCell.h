//
//  OrderlinesIarcosBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderlinesIarcosBaseTableViewCell : UITableViewCell {
    UILabel* _orderPadDetails;
    UILabel* _productCode;
    UILabel* _productSize;
    UILabel* _myDescription;
    UILabel* _value;
}

@property (nonatomic,retain) IBOutlet UILabel* orderPadDetails;
@property (nonatomic,retain) IBOutlet UILabel* productCode;
@property (nonatomic,retain) IBOutlet UILabel* productSize;
@property (nonatomic,retain) IBOutlet UILabel* myDescription;
@property (nonatomic,retain) IBOutlet UILabel* value;

-(void)configCellWithData:(NSMutableDictionary*)theData;

@end
