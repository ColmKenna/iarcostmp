//
//  PhotoFileInfoProvider.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoFileInfoProvider : NSObject {

}

- (NSMutableArray*)retrievePartialPhotoInfo;
- (NSMutableArray*)retrieveFullPhotoInfo;

@end
