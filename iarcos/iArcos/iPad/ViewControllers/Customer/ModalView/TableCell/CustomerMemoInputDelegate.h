//
//  CustomerMemoInputDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerMemoInputDelegate <NSObject>

@optional
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
-(UIViewController*)retrieveParentViewController;

@end
