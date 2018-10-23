//
//  ReportMeetingHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 17/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportMeetingHeaderView : UIView {
    UILabel* _detailsLabel;
    UILabel* _typeLabel;
    UILabel* _statusLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* detailsLabel;
@property(nonatomic, retain) IBOutlet UILabel* typeLabel;
@property(nonatomic, retain) IBOutlet UILabel* statusLabel;


@end
