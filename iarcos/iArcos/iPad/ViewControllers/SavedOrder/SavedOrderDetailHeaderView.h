//
//  SavedOrderDetailHeaderView.h
//  iArcos
//
//  Created by Richard on 04/05/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedOrderDetailHeaderView : UIView {
    UILabel* _locationLabel;
    UILabel* _goodsLabel;
    UILabel* _vatLabel;
    UILabel* _totalLabel;
}

@property (nonatomic,retain) IBOutlet UILabel* locationLabel;
@property (nonatomic,retain) IBOutlet UILabel* goodsLabel;
@property (nonatomic,retain) IBOutlet UILabel* vatLabel;
@property (nonatomic,retain) IBOutlet UILabel* totalLabel;

@end


