//
//  ArcosMailDataUtils.h
//  iArcos
//
//  Created by David Kilmartin on 08/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosMailDataUtils : NSObject

- (NSMutableDictionary*)calculateHeightWithText:(NSString *)aText;
- (NSMutableDictionary*)calculateHeightWithWebViewHeight:(float)aHeight;

@end
