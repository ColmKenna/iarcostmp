//
//  FlagsContactTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FlagsContactTableViewControllerDelegate <NSObject>
- (void)didSelectFlagsContactRecord:(NSMutableDictionary*)aContactDict;
- (NSMutableDictionary*)retrieveContactParentOrderCart;
@end

