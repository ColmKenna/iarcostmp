//
//  CustomerCalendarListHeaderView.h
//  iArcos
//
//  Created by Richard on 05/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerCalendarListHeaderView : UIView {
    UILabel* _startdatePointerLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* startdatePointerLabel;

@end

