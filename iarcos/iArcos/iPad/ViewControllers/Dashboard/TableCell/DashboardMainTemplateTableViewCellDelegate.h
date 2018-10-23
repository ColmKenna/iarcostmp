//
//  DashboardMainTemplateTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 20/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DashboardMainTemplateTableViewCellDelegate <NSObject>

- (void)dashboardBoxPressedWithIUR:(int)anIUR;

@end
