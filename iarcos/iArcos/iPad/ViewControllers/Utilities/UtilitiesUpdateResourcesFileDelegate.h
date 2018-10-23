//
//  UtilitiesUpdateResourcesFileDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 14/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UtilitiesUpdateResourcesFileDelegate <NSObject>
@required
- (void)didFinishLoadingResourcesFileDelegate:(NSError *)anError;
- (void)didFailWithErrorResourcesFileDelegate:(NSError *)anError;
- (void)updateResourcesProgressBar:(float)aValue;
//- (void)didFailWithErrorResourcesFileDelegate:(NSError *)anError;
- (void)errorWithResourcesFile:(NSError *)anError;

@end
