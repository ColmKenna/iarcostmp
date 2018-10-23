//
//  PriceChangeBaseTableCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 15/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PriceChangeBaseTableCellDelegate <NSObject>

- (void)inputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath*)theIndexPath;

@end
