//
//  UploadFunctionTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFunctionTableViewCellDelegate.h"

@interface UploadFunctionTableViewCell : UITableViewCell {
    id<UploadFunctionTableViewCellDelegate> _myDelegate;
    UIButton* _uploadButton;
}

@property(nonatomic, assign) id<UploadFunctionTableViewCellDelegate> myDelegate;
@property(nonatomic, assign) IBOutlet UIButton* uploadButton;

- (IBAction)pressUploadFunctionButton:(id)sender;

@end
