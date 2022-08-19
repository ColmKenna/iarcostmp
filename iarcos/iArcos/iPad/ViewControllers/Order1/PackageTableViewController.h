//
//  PackageTableViewController.h
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "PackageDataManager.h"
#import "PackageTableViewCell.h"
#import "PackageTableViewControllerDelegate.h"

@interface PackageTableViewController : UITableViewController <PackageTableViewCellDelegate>{
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    id<PackageTableViewControllerDelegate> _actionDelegate;
    PackageDataManager* _packageDataManager;
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, assign) id<PackageTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) PackageDataManager* packageDataManager;

@end


