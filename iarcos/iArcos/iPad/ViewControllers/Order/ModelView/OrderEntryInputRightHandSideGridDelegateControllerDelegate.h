//
//  OrderEntryInputRightHandSideGridDelegateControllerDelegate.h
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol OrderEntryInputRightHandSideGridDelegateControllerDelegate <NSObject>

- (UIView*)retrieveRightHandSideGridHeaderView;
- (NSNumber*)retrieveLocationIUR;
- (id)retrieveCellData;
- (UIView*)retrieveRightHandSideGridFooterView;

@end

