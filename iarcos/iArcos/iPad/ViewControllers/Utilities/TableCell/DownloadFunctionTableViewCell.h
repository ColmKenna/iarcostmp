//
//  DownloadFunctionTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadFunctionTableViewCellDelegate.h"

@interface DownloadFunctionTableViewCell : UITableViewCell {
    id<DownloadFunctionTableViewCellDelegate> _myDelegate;
    UIButton* _downloadButton;
}

@property(nonatomic, assign) id<DownloadFunctionTableViewCellDelegate> myDelegate;
@property(nonatomic, retain) IBOutlet UIButton* downloadButton;

- (IBAction)pressDownloadFunctionButton:(id)sender;

@end
