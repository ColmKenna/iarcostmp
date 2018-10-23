//
//  GetRecordGenericTypeTableCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 23/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetRecordGenericTypeTableCellDelegate <NSObject>

- (void)inputFinishedWithData:(id)aContentString actualData:(id)anActualData indexPath:(NSIndexPath*)anIndexPath;

@end
