//
//  FormRowsFooterMatTableViewController.h
//  iArcos
//
//  Created by Richard on 12/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormRowsFooterMatDataManager.h"
#import "FormRowsFooterMatHeaderView.h"
#import "FormRowsFooterMatTableViewCell.h"

@interface FormRowsFooterMatTableViewController : UITableViewController {
    FormRowsFooterMatDataManager* _formRowsFooterMatDataManager;
    FormRowsFooterMatHeaderView* _formRowsFooterMatHeaderView;
    
}

@property(nonatomic, retain) FormRowsFooterMatDataManager* formRowsFooterMatDataManager;
@property(nonatomic, retain) IBOutlet FormRowsFooterMatHeaderView* formRowsFooterMatHeaderView;

@end


