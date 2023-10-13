//
//  FlagsLocationTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 09/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FlagsLocationTableViewControllerDelegate <NSObject>
- (void)didSelectFlagsLocationRecord:(NSMutableDictionary*)aCustDict;
@end

