//
//  DashboardVanStocksDetailTableCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DashboardVanStocksDetailTableCellDelegate <NSObject>

- (void)inputFinishedWithData:(NSString*)aData indexPath:(NSIndexPath*)anIndexPath;
- (void)updateButtonPressedDelegate;

@end
