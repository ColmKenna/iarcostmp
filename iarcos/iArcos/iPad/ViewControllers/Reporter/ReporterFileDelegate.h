//
//  ReporterFileDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 15/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReporterFileDelegate <NSObject>
@required
- (void)didFinishLoadingReporterFileDelegate;
- (void)didFailWithErrorReporterFileDelegate:(NSError *)anError;

@end
