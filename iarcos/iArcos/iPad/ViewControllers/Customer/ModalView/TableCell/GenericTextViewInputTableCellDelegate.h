//
//  GenericTextViewInputTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericTextViewInputTableCellDelegate <NSObject>

@optional
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
-(UIViewController*)retrieveParentViewController;

@end
