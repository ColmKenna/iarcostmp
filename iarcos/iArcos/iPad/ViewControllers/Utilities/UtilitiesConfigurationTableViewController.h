//
//  UtilitiesConfigurationTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "UtilitiesConfigurationTableCell.h"
#import "UtilitiesConfigurationDataManager.h"

@interface UtilitiesConfigurationTableViewController : UtilitiesDetailViewController <GenericTextViewInputTableCellDelegate> {
    UtilitiesConfigurationDataManager* _utilitiesConfigurationDataManager;
}

@property(nonatomic, retain) UtilitiesConfigurationDataManager* utilitiesConfigurationDataManager;

@end
