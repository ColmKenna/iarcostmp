//
//  FlagsContactFlagTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 20/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FlagsContactFlagTableViewControllerDelegate <NSObject>
- (void)refreshParentContentWithContactFlagIUR:(NSNumber*)anIUR;
- (NSString*)retrieveParentFlagDescrTypeCode;
- (NSString*)retrieveParentActionTypeTitle;
@end


