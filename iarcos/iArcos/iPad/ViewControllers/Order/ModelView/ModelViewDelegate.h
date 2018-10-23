//
//  ModelViewProtocol.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ModelViewDelegate <NSObject>
@optional
- (void)didDismissModalView;
- (void)savePressedWithNewData:(NSMutableDictionary*)theData;

@end
