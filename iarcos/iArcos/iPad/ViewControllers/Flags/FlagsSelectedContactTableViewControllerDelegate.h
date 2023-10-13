//
//  FlagsSelectedContactTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 12/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FlagsSelectedContactTableViewControllerDelegate <NSObject>
- (void)didSelectFlagsSelectedContactRecord:(NSMutableDictionary*)aContactDict;
@end

