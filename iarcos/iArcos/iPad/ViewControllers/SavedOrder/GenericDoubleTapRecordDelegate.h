//
//  GenericDoubleTapRecordDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 04/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericDoubleTapRecordDelegate <NSObject>

- (void)customiseDoubleTapRecord:(NSIndexPath*)anIndexPath;

@end
