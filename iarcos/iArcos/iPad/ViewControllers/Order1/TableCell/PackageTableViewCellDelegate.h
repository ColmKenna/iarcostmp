//
//  PackageTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 26/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PackageTableViewCellDelegate <NSObject>


- (NSMutableDictionary*)retrieveWholesalerIurImageIurHashMap;
- (NSMutableDictionary*)retrievePGiurDetailHashMap;
- (void)rowPressedWithIndexPath:(NSIndexPath*)anIndexPath;

@end


