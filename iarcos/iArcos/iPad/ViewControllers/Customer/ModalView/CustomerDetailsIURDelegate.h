//
//  CustomerDetailsIURDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 05/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerDetailsIURDelegate <NSObject>

-(void)detailsIURFinishEditing:(id)aContentString actualContent:(id)anActualContent WithIndexPath:(NSIndexPath *)indexPath;

@end
