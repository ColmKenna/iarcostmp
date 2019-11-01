//
//  DrawingAreaDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 31/10/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DrawingAreaDelegate <NSObject>

@optional
- (void)touchEndedWithData:(NSMutableArray*)aDataList;

@end

