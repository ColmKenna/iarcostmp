//
//  ResourcesUpdateCenterDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 14/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResourcesUpdateCenterDelegate <NSObject>
@required
-(void)resourcesUpdateCompleted:(int)anOverallFileCount;
- (void)didFailWithErrorResourcesFileDelegate:(NSError *)anError;
- (void)checkFileMD5Completed;
- (void)checkFileExistenceCompleted;
@optional
- (void)updateResourcesProgressBar:(float)aValue;
- (void)ResourceStatusTextWithValue:(NSString*)aValue;
- (void)errorWithResourcesFile:(NSError *)anError;
@end
