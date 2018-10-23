//
//  UploadProcessCenter.h
//  iArcos
//
//  Created by David Kilmartin on 07/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadWebServiceProcessor.h"

@interface UploadProcessCenter : NSObject <UploadWebServiceProcessorDelegate>{
    id<UploadWebServiceProcessorDelegate> _myDelegate;
    UploadWebServiceProcessor* _webServiceProcessor;
    NSMutableArray* _selectorList;
    NSDictionary* _currentSelectorDict;
    int _selectorListCount;
    BOOL _isBusy;
    NSTimer* _performTimer;
}

@property(nonatomic, assign) id<UploadWebServiceProcessorDelegate> myDelegate;
@property(nonatomic, retain) UploadWebServiceProcessor* webServiceProcessor;
@property(nonatomic, retain) NSMutableArray* selectorList;
@property(nonatomic, retain) NSDictionary* currentSelectorDict;
@property(nonatomic, assign) int selectorListCount;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* performTimer;

- (void)pushSelector:(SEL)aSelector name:(NSString*)aName;
- (NSDictionary*)popSelector;
- (void)stopTask;
- (void)startPerformSelectorList;

@end
