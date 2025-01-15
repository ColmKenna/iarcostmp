//
//  UpdateCenter.m
//  Arcos
//
//  Created by David Kilmartin on 05/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UpdateCenter.h"
#import "GlobalSharedClass.h"

@implementation UpdateCenter
@synthesize selectors;
@synthesize selectorsCount = _selectorsCount;
@synthesize serviceClass;
@synthesize performTimer;
@synthesize calculateBeginDate = _calculateBeginDate;
@synthesize calculateEndDate = _calculateEndDate;
@synthesize currentSelectorName;
@synthesize delegate;
@synthesize orderStartDate;
@synthesize orderEndDate;
@synthesize callStartDate = _callStartDate;
@synthesize callEndDate = _callEndDate;
@synthesize responseStartDate = _responseStartDate;
@synthesize responseEndDate = _responseEndDate;

-(id)init{
    self=[super init];
    if (self!=nil) {
        self.serviceClass=[WebServiceSharedClass sharedWebServiceSharedClass];
        self.serviceClass.delegate=self;
        self.selectors=[NSMutableArray array];
        
        self.calculateBeginDate = nil;
        self.calculateEndDate = nil;
        timeoutInterval=0;
        totalTimeUsed=0;
        
        isBusy=NO;
        self.orderStartDate = [ArcosUtils addMonths:-1 date:[NSDate date]];
        self.orderEndDate = [NSDate date];
        self.callStartDate = [ArcosUtils addMonths:-1 date:[NSDate date]];
        self.callEndDate = [NSDate date];
        self.responseStartDate = [ArcosUtils addMonths:-1 date:[NSDate date]];
        self.responseEndDate = [NSDate date];
//        NSLog(@"date in updatecenter is: %@ %@", self.orderStartDate, self.orderEndDate);
    }
    return self;
}

- (void)dealloc {
    if (self.serviceClass != nil) { self.serviceClass = nil; }
    if (self.selectors != nil) { self.selectors = nil; }
    if (self.currentSelectorName != nil) { self.currentSelectorName = nil; }    
    if (self.performTimer != nil) { self.performTimer = nil; }
    self.calculateBeginDate = nil;
    self.calculateEndDate = nil;
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.orderStartDate != nil) { self.orderStartDate = nil; }
    if (self.orderEndDate != nil) { self.orderEndDate = nil; }
    if (self.callStartDate != nil) { self.callStartDate = nil; }
    if (self.callEndDate != nil) { self.callEndDate = nil; }
    self.responseStartDate = nil;
    self.responseEndDate = nil;
            
    [super dealloc];
}

//-(void)pushSelector:(SEL)aSelector{
//    [self.selectors addObject:[NSValue valueWithPointer:aSelector]];
//}
-(void)removeSelectorWithName:(NSString*)aName{
    NSDictionary* dictToDelete=nil;
    for (NSDictionary* selectorDict in self.selectors) {
        if ([aName isEqualToString:[selectorDict objectForKey:@"name"]]) {
            dictToDelete=selectorDict;
        }
    }
    if (dictToDelete!=nil) {
        [self.selectors removeObject:dictToDelete];
    }
}
-(void)removeAllSelectors{
    [self.performTimer invalidate];
    self.performTimer=nil;
    [self.selectors removeAllObjects];
    isBusy=NO;
    self.serviceClass.isLoadingFinished = YES;
}
-(void)pushSelector:(SEL)aSelector withName:(NSString*)aName{
    
    NSDictionary* aSelDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithPointer:aSelector], aName,nil] forKeys:[NSArray arrayWithObjects:@"selector",@"name", nil]];
    [self.selectors addObject:aSelDict];
}
-(SEL)popSelector{
//    if ([self.selectors count]>0) {
//        NSValue* selectorValue=[[[self.selectors lastObject]retain]autorelease];
//        SEL selector= [selectorValue pointerValue];
//        if (selectorValue)
//            [self.selectors removeLastObject];
//        return selector;
//    }
//    return nil;
    if ([self.selectors count]>0) {
        NSDictionary* tempDict=[[[self.selectors lastObject]retain]autorelease];
        if (tempDict){
            [self.selectors removeLastObject];
        }else{
            return nil;
        }
        
        SEL selector= [[tempDict objectForKey:@"selector"] pointerValue];
        self.currentSelectorName=[tempDict objectForKey:@"name"];
        
        return selector;
    }
    return nil;
    
}

-(void)startPreformSelectors{
    NSLog(@"update started.");
    if ([self.selectors count]<=0||isBusy) {
        return;
    }
    
    //set the service time out interval
    [GlobalSharedClass shared].serviceTimeoutInterval=600.0;
    
    if (self.serviceClass.isLoadingFinished) {
        self.selectorsCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.selectors count]];
        [self.delegate RetrievingProcessInitiation];
    isBusy=YES;
        self.performTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkSelectorQueue) userInfo:nil repeats:YES];
    }
}
-(void)checkSelectorQueue{
    totalTimeUsed++;
    //timeoutInterval++;
    if (self.calculateBeginDate == nil) {
        self.calculateBeginDate = [NSDate date];
    }
    if (timeoutInterval>=120) {
        NSLog(@"update time out.");
        [self.delegate TimeOutFor:self.currentSelectorName];
        //[self.performTimer invalidate];
        self.serviceClass.isLoadingFinished=YES;
    }
    
    if (self.serviceClass.isLoadingFinished) {
        timeoutInterval=0;
        
        //stop the timer
        if ([self.selectors count]<=0) {
            [self.performTimer invalidate];
            //[self.performTimer release];
            self.performTimer=nil;
            self.calculateEndDate = [NSDate date];
            NSLog(@"update finished. using--%f seconds",[self.calculateEndDate timeIntervalSinceDate:self.calculateBeginDate]);
            [self.delegate UpdateCompleted];
            isBusy=NO;
            
            //set the service time out interval back to default
            [GlobalSharedClass shared].serviceTimeoutInterval=60.0;
            self.calculateBeginDate = nil;
        }else{
            //get a selector
            SEL aSelector=[self popSelector];
            if (aSelector != nil) {
                [GlobalSharedClass shared].currentSelectorName = self.currentSelectorName;
            }
            if (aSelector==nil) {
                
            } else if([self.currentSelectorName isEqualToString:[GlobalSharedClass shared].orderHeaderSelectorName]) {                
                NSIndexPath* orderSelectorIndexPath = [self.serviceClass.paginatedRequestObjectProvider.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:[GlobalSharedClass shared].orderHeaderSelectorName];
                NSMutableDictionary* auxOrderDataDict = [self.serviceClass.paginatedRequestObjectProvider.utilitiesUpdateDetailDataManager.dataTablesDisplayList objectAtIndex:orderSelectorIndexPath.section];
                NSNumber* orderDownloadMode = [auxOrderDataDict objectForKey:@"DownloadMode"];
                NSMutableDictionary* paramDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
                [paramDataDict setObject:orderDownloadMode forKey:@"DownloadMode"];
                if ([orderDownloadMode intValue] == 1) {//partial
                    NSDate* partialOrderStartDate = [NSDate date];
                    NSDate* partialOrderEndDate = [NSDate date];
                    if ([[auxOrderDataDict objectForKey:@"IsDownloaded"] boolValue]) {
                        partialOrderStartDate = [auxOrderDataDict objectForKey:@"DownloadDate"];
                    }
                    [paramDataDict setObject:[ArcosUtils beginOfDay:partialOrderStartDate] forKey:@"StartDate"];
                    [paramDataDict setObject:[ArcosUtils endOfDay:partialOrderEndDate] forKey:@"EndDate"];
//                    [self.serviceClass performSelector:aSelector withObject:[ArcosUtils beginOfDay:partialOrderStartDate] withObject:[ArcosUtils endOfDay:partialOrderEndDate]];
                    [self.serviceClass performSelector:aSelector withObject:paramDataDict];
                } else {
                    [paramDataDict setObject:[ArcosUtils beginOfDay:self.orderStartDate] forKey:@"StartDate"];
                    [paramDataDict setObject:[ArcosUtils endOfDay:self.orderEndDate] forKey:@"EndDate"];
//                    [self.serviceClass performSelector:aSelector withObject:[ArcosUtils beginOfDay:self.orderStartDate] withObject:[ArcosUtils endOfDay:self.orderEndDate]];
                    [self.serviceClass performSelector:aSelector withObject:paramDataDict];
                }
            } else if([self.currentSelectorName isEqualToString:[GlobalSharedClass shared].callOrderHeaderSelectorName]) {
                NSIndexPath* callSelectorIndexPath = [self.serviceClass.paginatedRequestObjectProvider.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:[GlobalSharedClass shared].callOrderHeaderSelectorName];
                NSMutableDictionary* auxCallDataDict = [self.serviceClass.paginatedRequestObjectProvider.utilitiesUpdateDetailDataManager.dataTablesDisplayList objectAtIndex:callSelectorIndexPath.section];
                NSNumber* callDownloadMode = [auxCallDataDict objectForKey:@"DownloadMode"];
                NSMutableDictionary* paramDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
                [paramDataDict setObject:callDownloadMode forKey:@"DownloadMode"];
                if ([callDownloadMode intValue] == 1) {//partial
                    NSDate* partialCallStartDate = [NSDate date];
                    NSDate* partialCallEndDate = [NSDate date];
                    if ([[auxCallDataDict objectForKey:@"IsDownloaded"] boolValue]) {
                        partialCallStartDate = [auxCallDataDict objectForKey:@"DownloadDate"];
                    }
                    [paramDataDict setObject:[ArcosUtils beginOfDay:partialCallStartDate] forKey:@"StartDate"];
                    [paramDataDict setObject:[ArcosUtils endOfDay:partialCallEndDate] forKey:@"EndDate"];
//                    [self.serviceClass performSelector:aSelector withObject:[ArcosUtils beginOfDay:partialCallStartDate] withObject:[ArcosUtils endOfDay:partialCallEndDate]];
                    [self.serviceClass performSelector:aSelector withObject:paramDataDict];
                } else {
                    [paramDataDict setObject:[ArcosUtils beginOfDay:self.callStartDate] forKey:@"StartDate"];
                    [paramDataDict setObject:[ArcosUtils endOfDay:self.callEndDate] forKey:@"EndDate"];
//                    [self.serviceClass performSelector:aSelector withObject:[ArcosUtils beginOfDay:self.callStartDate] withObject:[ArcosUtils endOfDay:self.callEndDate]];
                    [self.serviceClass performSelector:aSelector withObject:paramDataDict];
                }
            } else if([self.currentSelectorName isEqualToString:[GlobalSharedClass shared].responseSelectorName]) {
                [self.serviceClass performSelector:aSelector withObject:[ArcosUtils beginOfDay:self.responseStartDate] withObject:[ArcosUtils endOfDay:self.responseEndDate]];
            } else{
                [self.serviceClass performSelector:aSelector];
            }
        }
        
    }

}
#pragma mark webservice delegate
-(void)StartGettingData{
    //NSLog(@"start getting data for ---%@",currentSelectorName);
    [self.delegate StartGettingDataFor:currentSelectorName];
}
-(void)GotData:(NSUInteger)dataCount{
    //NSLog(@"got %d records for ---%@",dataCount, currentSelectorName);
    [self.delegate GotData:dataCount];
}
-(void)UpdateData {
    [self.delegate UpdateData:currentSelectorName];
}
-(void)CommitData {
    [self.delegate CommitData:currentSelectorName];
}
-(void)LoadingData:(int)currentDataCount{
    //NSLog(@"%@ loading in progress ---%d",currentSelectorName,currentDataCount);
    [self.delegate LoadingData:currentDataCount];
}
-(void)FinishLoadingData:(NSUInteger)anOverallNumber{
    //NSLog(@"%@ is finished load",currentSelectorName);
    [self.delegate FinishLoadingDataFor:currentSelectorName overallNumber:anOverallNumber];
}
-(void)ErrorOccured:(NSString*)errorDesc{
    //NSLog(@"Error for %@ loading--%@",currentSelectorName,errorDesc);
    self.calculateBeginDate = nil;
    [self.delegate ErrorOccured:errorDesc];
    [self removeAllSelectors];

}

-(void)ProgressViewWithValue:(float)aProgressValue {
    [self.delegate ProgressViewWithValue:aProgressValue];
}

-(void)ProgressViewWithValueWithoutAnimation:(float)aProgressValue {
    [self.delegate ProgressViewWithValueWithoutAnimation:aProgressValue];
}

-(void)ResourceStatusTextWithValue:(NSString*)aValue {
    [self.delegate ResourceStatusTextWithValue:aValue];
}

- (void)GotFailWithErrorResourcesFileDelegate:(NSError *)anError {
    [self.delegate GotFailWithErrorResourcesFileDelegate:anError];
    [self removeAllSelectors];
}

- (void)GotErrorWithResourcesFile:(NSError *)anError {
    [self.delegate GotErrorWithResourcesFile:anError];
}

- (UIViewController*)retrieveWebServiceParentViewController {
    return [self.delegate retrieveUpdateCenterParentViewController];
}


-(void)ProgressViewWithValueForPaginatedProducts:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedProducts:aProgressValue];
}

-(void)ProgressViewWithValueForProducts:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForProducts:aProgressValue];
}

-(void)ProgressViewWithValueForPrice:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPrice:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedLocations:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedLocations:aProgressValue];
}

-(void)ProgressViewWithValueForPackage:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPackage:aProgressValue];
}

-(void)ProgressViewWithValueForLocations:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForLocations:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedLocLocLink:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedLocLocLink:aProgressValue];
}

-(void)ProgressViewWithValueForLocLocLink:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForLocLocLink:aProgressValue];
}

-(void)ProgressViewWithValueForLocationProductMAT:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForLocationProductMAT:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedDescrDetails:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedDescrDetails:aProgressValue];
}

-(void)ProgressViewWithValueForDescrDetails:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForDescrDetails:aProgressValue];
}

-(void)ProgressViewWithValueForFormDetails:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForFormDetails:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedFormRows:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedFormRows:aProgressValue];
}

-(void)ProgressViewWithValueForFormRows:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForFormRows:aProgressValue];
}

-(void)ProgressViewWithValueForWholeSalers:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForWholeSalers:aProgressValue];
}

-(void)ProgressViewWithValueForDescriptionType:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForDescriptionType:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedContacts:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedContacts:aProgressValue];
}

-(void)ProgressViewWithValueForContact:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForContact:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedConLocLink:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedConLocLink:aProgressValue];
}

-(void)ProgressViewWithValueForConLocLink:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForConLocLink:aProgressValue];
}

-(void)ProgressViewWithValueForPresenter:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPresenter:aProgressValue];
}

-(void)ProgressViewWithValueForPaginatedImage:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForPaginatedImage:aProgressValue];
}

-(void)ProgressViewWithValueForImage:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForImage:aProgressValue];
}

-(void)ProgressViewWithValueForEmployee:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForEmployee:aProgressValue];
}

-(void)ProgressViewWithValueForConfig:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForConfig:aProgressValue];
}

-(void)ProgressViewWithValueForOrder:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForOrder:aProgressValue];
}

-(void)ProgressViewWithValueForCall:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForCall:aProgressValue];
}

-(void)ProgressViewWithValueForResponse:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForResponse:aProgressValue];
}

-(void)ProgressViewWithValueForSurvey:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForSurvey:aProgressValue];
}

-(void)ProgressViewWithValueForJourney:(float)aProgressValue {
    [self.delegate ProgressViewWithValueForJourney:aProgressValue];
}
@end
