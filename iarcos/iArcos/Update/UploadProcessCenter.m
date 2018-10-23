//
//  UploadProcessCenter.m
//  iArcos
//
//  Created by David Kilmartin on 07/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UploadProcessCenter.h"

@implementation UploadProcessCenter
@synthesize myDelegate = _myDelegate;
@synthesize webServiceProcessor = _webServiceProcessor;
@synthesize selectorList = _selectorList;
@synthesize currentSelectorDict = _currentSelectorDict;
@synthesize selectorListCount = _selectorListCount;
@synthesize isBusy = _isBusy;
@synthesize performTimer = _performTimer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.webServiceProcessor = [[[UploadWebServiceProcessor alloc] init] autorelease];
        self.webServiceProcessor.myDelegate = self;
        self.selectorList = [NSMutableArray array];
        self.isBusy = NO;
    }
    return self;
}

- (void)dealloc {
    self.webServiceProcessor = nil;
    self.selectorList = nil;
    self.currentSelectorDict = nil;
    self.performTimer = nil;
    
    [super dealloc];
}

- (void)pushSelector:(SEL)aSelector name:(NSString*)aName {
    NSDictionary* tmpSelDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithPointer:aSelector], aName, nil] forKeys:[NSArray arrayWithObjects:@"selector", @"name", nil]];
    [self.selectorList addObject:tmpSelDict];
}

- (NSDictionary*)popSelector {
    if ([self.selectorList count] > 0) {
        NSDictionary* tmpDict = [[[self.selectorList lastObject] retain] autorelease];
        if (tmpDict) {
            [self.selectorList removeLastObject];
        } else {
            return nil;
        }
        
        self.currentSelectorDict = tmpDict;
        return tmpDict;
    }
    return nil;
}

- (void)stopTask {
    [self.performTimer invalidate];
    self.performTimer = nil;
    [self.selectorList removeAllObjects];
    self.isBusy = NO;
    self.webServiceProcessor.isUploadingFinished = YES;
    [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
}

- (void)startPerformSelectorList {
    if ([self.selectorList count] <= 0 || self.isBusy) return;
    
    //set the service time out interval
    [GlobalSharedClass shared].serviceTimeoutInterval = 600.0;
    
    self.selectorListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.selectorList count]];
    self.isBusy = YES;
    [self.myDelegate uploadBranchProcessInitiation];
    self.performTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkSelectorStack) userInfo:nil repeats:YES];
}

- (void)checkSelectorStack {
    if (!self.webServiceProcessor.isUploadingFinished) return;
    if ([self.selectorList count] <= 0) {
        [self.performTimer invalidate];
        self.performTimer = nil;
        [self.myDelegate uploadBranchProcessCompleted];
        self.isBusy = NO;
        
        //set the service time out interval back to default
        [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
    } else {
        NSDictionary* topSelectorDict = [self popSelector];
        if (topSelectorDict == nil) return;
//        [GlobalSharedClass shared].currentSelectorName = [topSelectorDict objectForKey:@"name"];
        SEL topSelector = [[topSelectorDict objectForKey:@"selector"] pointerValue];
        [self.webServiceProcessor performSelector:topSelector];
    }
}

#pragma mark UploadWebServiceProcessorDelegate
- (void)uploadProcessStarted {
    [self.myDelegate uploadProcessStarted];
}

- (void)uploadProcessWithText:(NSString*)aText {
    [self.myDelegate uploadProcessWithText:aText];
}

- (void)uploadProgressViewWithValue:(float)aProgressValue {
    [self.myDelegate uploadProgressViewWithValue:aProgressValue];
}

- (void)uploadProcessFinished:(NSString*)aSelectorName sectionTitle:(NSString*)aSectionTitle overallNumber:(int)anOverallNumber {
    [self.myDelegate uploadProcessFinished:[self.currentSelectorDict objectForKey:@"name"] sectionTitle:aSectionTitle overallNumber:anOverallNumber];
}

- (void)uploadProcessWithErrorMsg:(NSString*)anErrorMsg {
    [self.myDelegate uploadProcessWithErrorMsg:anErrorMsg];
    [self stopTask];
}

@end
