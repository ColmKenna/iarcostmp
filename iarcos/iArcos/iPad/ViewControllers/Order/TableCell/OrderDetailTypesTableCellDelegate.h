//
//  OrderDetailTypesTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderDetailTypesTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
@optional
-(void)showOrderlineDetailsDelegate;
-(void)showCallDetailsDelegate;
-(void)showRemoteOrderlineDetailsDelegate;
-(void)showRemoteCallDetailsDelegate;
-(UIViewController*)retrieveParentViewController;
-(void)showPrintViewControllerDelegate;
- (void)locationInputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (NSMutableDictionary*)retrieveParentOrderHeader;
- (void)showInvoiceDetailViewController;
- (void)showOrderDetailViewController;

@end
