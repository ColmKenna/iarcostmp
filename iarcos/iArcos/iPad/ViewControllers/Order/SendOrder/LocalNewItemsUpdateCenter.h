//
//  LocalNewItemsUpdateCenter.h
//  Arcos
//
//  Created by David Kilmartin on 16/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosServices.h"
#import "LocalNewItemsUpdateCenterDelegate.h"
//@protocol LocalNewItemsUpdateCenterDelegate <NSObject>
//- (void)didFinishLocalNewItemsSending;
//@end
#import "LocalNewItemsWebServiceProcessor.h"
#import "ArcosConfigDataManager.h"

@interface LocalNewItemsUpdateCenter : NSObject<LocalNewItemsUpdateCenterDelegate>{
    id<LocalNewItemsUpdateCenterDelegate> _localItemsDelegate;
//    ArcosService* _arcosService;
    LocalNewItemsWebServiceProcessor* _itemsWebServiceProcessor;
    NSMutableArray* _selectorList;
    NSDictionary* _currentSelectorDict;
    int _selectorListCount;
    BOOL _isBusy;
    NSTimer* _performTimer;
}
@property(nonatomic, assign) id<LocalNewItemsUpdateCenterDelegate> localItemsDelegate;
//@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, retain) LocalNewItemsWebServiceProcessor* itemsWebServiceProcessor;
@property(nonatomic, retain) NSMutableArray* selectorList;
@property(nonatomic, retain) NSDictionary* currentSelectorDict;
@property(nonatomic, assign) int selectorListCount;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* performTimer;

//-(void)updateAll;
//-(void)updateLocationToServer;
//-(void)updateRespondToServer;
//- (void)uploadPhotosToServer;
//-(NSMutableArray*)locationArray;
//-(NSMutableArray*)responseArray;
//-(BOOL)errorCheck:(id)result;

- (void)pushSelector:(SEL)aSelector name:(NSString*)aName;
- (NSDictionary*)popSelector;
- (void)stopTask;
- (void)startPerformSelectorList;
- (void)buildProcessSelectorList;
@end
