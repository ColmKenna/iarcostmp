//
//  ReportLocationHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 19/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportLocationHeaderView : UIView {
    UILabel* _locationLabel;
    UILabel* _contactLabel;
    UILabel* _typeLabel;
    UILabel* _lastCallLabel;
    UILabel* _lastOrderLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) IBOutlet UILabel* contactLabel;
@property(nonatomic, retain) IBOutlet UILabel* typeLabel;
@property(nonatomic, retain) IBOutlet UILabel* lastCallLabel;
@property(nonatomic, retain) IBOutlet UILabel* lastOrderLabel;

@end
