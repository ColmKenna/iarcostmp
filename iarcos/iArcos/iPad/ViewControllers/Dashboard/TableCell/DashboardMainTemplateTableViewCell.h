//
//  DashboardMainTemplateTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardMainTemplateDataObject.h"
#import "DashboardMainTemplateBaseButton.h"
#import "DashboardMainTemplateTableViewCellDelegate.h"

@interface DashboardMainTemplateTableViewCell : UITableViewCell {
//    NSMutableArray* _dictList;
    id<DashboardMainTemplateTableViewCellDelegate> _cellDelegate;
}

@property(nonatomic, assign) id<DashboardMainTemplateTableViewCellDelegate> cellDelegate;

- (void)configCellWithData:(NSMutableArray*)aDictList;

@end
