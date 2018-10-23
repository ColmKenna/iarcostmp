//
//  PresenterBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 19/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "PTran.h"
#import "CoreLocationController.h"

@interface PresenterBaseDataManager : NSObject <CoreLocationControllerDelegate>{
    CoreLocationController* _CLController;
    NSNumber* _latitude;
    NSNumber* _longitude;
}

@property(nonatomic,retain) CoreLocationController* CLController;
@property(nonatomic,retain) NSNumber* latitude;
@property(nonatomic,retain) NSNumber* longitude;

- (void)loadPtranWithDict:(NSMutableDictionary*)aPtranDict;
- (NSMutableDictionary*)createPtranDictWithPresenterIUR:(NSNumber*)presenterIUR duration:(NSNumber*)duration;
- (void)recordLocationCoordinate;

@end
