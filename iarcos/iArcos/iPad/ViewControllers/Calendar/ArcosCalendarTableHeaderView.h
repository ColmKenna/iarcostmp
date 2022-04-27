//
//  ArcosCalendarTableHeaderView.h
//  iArcos
//
//  Created by Richard on 29/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ArcosCalendarTableHeaderView : UIView {
    UILabel* _monLabel;
    UILabel* _tueLabel;
    UILabel* _wedLabel;
    UILabel* _thuLabel;
    UILabel* _friLabel;
    UILabel* _satLabel;
    UILabel* _sunLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* monLabel;
@property(nonatomic, retain) IBOutlet UILabel* tueLabel;
@property(nonatomic, retain) IBOutlet UILabel* wedLabel;
@property(nonatomic, retain) IBOutlet UILabel* thuLabel;
@property(nonatomic, retain) IBOutlet UILabel* friLabel;
@property(nonatomic, retain) IBOutlet UILabel* satLabel;
@property(nonatomic, retain) IBOutlet UILabel* sunLabel;

@end


