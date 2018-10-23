//
//  ActivateProgressViewUpdateDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 29/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivateProgressViewUpdateDelegate <NSObject>

- (void)startImportData:(NSString*)aSelectorName;
- (void)activateProgressViewWithValue:(float)aProgressValue animated:(BOOL)flag;
- (void)completeLoadingData:(NSString*)aSelectorName;
- (void)mainLoadingComplete;
- (void)activateTableProgressViewWithValue:(float)aProgressValue animated:(BOOL)flag;
@end
