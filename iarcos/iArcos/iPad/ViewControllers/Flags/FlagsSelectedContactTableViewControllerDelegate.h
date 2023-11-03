//
//  FlagsSelectedContactTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 12/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol FlagsSelectedContactTableViewControllerDelegate <NSObject>
- (void)didSelectFlagsSelectedContactRecord:(NSMutableDictionary*)aContactDict;
- (MBProgressHUD*)retrieveProgressHUDFromParentViewController;
- (UIViewController*)retrieveSelectedContactParentViewController;
- (int)retrieveFlagsSelectedContactParentActionType;
- (NSNumber*)retrieveShowLocationCodeFlag;
- (void)didSelectFlagsSelectedLocationRecord:(NSMutableDictionary*)aLocationDict;
- (NSString*)retrieveFlagsSelectedContactParentFlagDescrTypeCode;
- (NSString*)retrieveFlagsSelectedContactParentActionTypeTitle;
- (NSString*)retrieveFlagsSelectedContactParentIURKeyText;
- (NSString*)retrieveFlagsSelectedContactParentAssignmentType;
@end

