//
//  StandardOrderPadMatHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 06/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardOrderPadMatHeaderView : UIView {
    UILabel* _descriptionLabel;
    UILabel* _month3;
    UILabel* _month4;
    UILabel* _month5;
    UILabel* _month6;
    UILabel* _month7;
    UILabel* _month8;
    UILabel* _month9;
    UILabel* _month10;
    UILabel* _month11;
    UILabel* _month12;
    UILabel* _month13;
    UILabel* _month14;
    UILabel* _month15;    
    UILabel* _totalLabel;
    UILabel* _qtyLabel;
    UILabel* _bonLabel;
    UILabel* _stockLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel* month3;
@property(nonatomic, retain) IBOutlet UILabel* month4;
@property(nonatomic, retain) IBOutlet UILabel* month5;
@property(nonatomic, retain) IBOutlet UILabel* month6;
@property(nonatomic, retain) IBOutlet UILabel* month7;
@property(nonatomic, retain) IBOutlet UILabel* month8;
@property(nonatomic, retain) IBOutlet UILabel* month9;
@property(nonatomic, retain) IBOutlet UILabel* month10;
@property(nonatomic, retain) IBOutlet UILabel* month11;
@property(nonatomic, retain) IBOutlet UILabel* month12;
@property(nonatomic, retain) IBOutlet UILabel* month13;
@property(nonatomic, retain) IBOutlet UILabel* month14;
@property(nonatomic, retain) IBOutlet UILabel* month15;    
@property(nonatomic, retain) IBOutlet UILabel* totalLabel;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel;
@property(nonatomic, retain) IBOutlet UILabel* stockLabel;

@end
