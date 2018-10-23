//
//  GenericRefreshParentContentDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 12/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericRefreshParentContentDelegate <NSObject>
- (void)refreshParentContent;
@optional
- (void)refreshParentContentByEdit;
- (void)refreshParentContentWithIUR:(NSNumber*)anIUR;
- (void)refreshParentContentByEditType:(BOOL)aFlag closeActualValue:(BOOL)aCloseActualValue indexPath:(NSIndexPath*)anIndexPath;
- (void)refreshParentContentByCreate:(NSIndexPath*)anIndexPath;
- (void)refreshParentContentWithData:(NSMutableDictionary*)aDataDict;
@end
