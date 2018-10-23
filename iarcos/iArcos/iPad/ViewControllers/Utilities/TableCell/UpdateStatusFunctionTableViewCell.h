//
//  UpdateStatusFunctionTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 13/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateStatusFunctionTableViewCell : UITableViewCell {
    UIActivityIndicatorView* _indicator;
    UIProgressView* _branchProgressBar;
    UIProgressView* _progressBar;
    UILabel* _updateStatus;
    UILabel* _statusTitleLabel;
}

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;
@property(nonatomic, retain) IBOutlet UIProgressView* branchProgressBar;
@property(nonatomic, retain) IBOutlet UIProgressView* progressBar;
@property(nonatomic, retain) IBOutlet UILabel* updateStatus;
@property(nonatomic, retain) IBOutlet UILabel* statusTitleLabel;

@end
