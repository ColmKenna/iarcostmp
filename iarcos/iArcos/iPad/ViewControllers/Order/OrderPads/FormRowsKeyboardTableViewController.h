//
//  FormRowsKeyboardTableViewController.h
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormRowsKeyboardDataManager.h"
#import "ModalPresentViewControllerDelegate.h"
#import "FormRowsKeyboardTableViewCell.h"

@interface FormRowsKeyboardTableViewController : UITableViewController <FormRowsKeyboardTableViewCellDelegate>{
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    FormRowsKeyboardDataManager* _formRowsKeyboardDataManager;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, retain) FormRowsKeyboardDataManager* formRowsKeyboardDataManager;

@end

