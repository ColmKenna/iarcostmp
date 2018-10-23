//
//  CustomerContactInputDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 29/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerContactInputDelegate <NSObject>

@optional
-(void)inputFinishedWithData:(id)aContentString actualContent:(id)anActualContent WithIndexPath:(NSIndexPath *)anIndexPath;

@end
