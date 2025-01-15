//
//  UpdateCenter.h
//  Arcos
//
//  Created by David Kilmartin on 05/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceSharedClass.h"
@protocol UpdateCenterDelegate
-(void)RetrievingProcessInitiation;
-(void)StartGettingDataFor:(NSString*)selectorName;
-(void)GotData:(NSUInteger)dataCount;
-(void)UpdateData:(NSString*)selectorName;
-(void)CommitData:(NSString*)selectorName;
-(void)LoadingData:(int)currentDataCount;
-(void)FinishLoadingDataFor:(NSString*)selectorName overallNumber:(NSUInteger)anOverallNumber;
-(void)ErrorOccured:(NSString*)errorDesc;
-(void)UpdateCompleted;
-(void)TimeOutFor:(NSString*)selectorName;
-(void)ProgressViewWithValue:(float)aProgressValue;
-(void)ProgressViewWithValueWithoutAnimation:(float)aProgressValue;
- (void)ResourceStatusTextWithValue:(NSString*)aValue;
- (void)GotFailWithErrorResourcesFileDelegate:(NSError *)anError;
- (void)GotErrorWithResourcesFile:(NSError *)anError;
- (UIViewController*)retrieveUpdateCenterParentViewController;

@optional
- (void)ProgressViewWithValueForPaginatedProducts:(float)aProgressValue;
- (void)ProgressViewWithValueForProducts:(float)aProgressValue;
- (void)ProgressViewWithValueForPrice:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedLocations:(float)aProgressValue;
- (void)ProgressViewWithValueForPackage:(float)aProgressValue;
- (void)ProgressViewWithValueForLocations:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedLocLocLink:(float)aProgressValue;
- (void)ProgressViewWithValueForLocLocLink:(float)aProgressValue;
- (void)ProgressViewWithValueForLocationProductMAT:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedDescrDetails:(float)aProgressValue;
- (void)ProgressViewWithValueForDescrDetails:(float)aProgressValue;
- (void)ProgressViewWithValueForFormDetails:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedFormRows:(float)aProgressValue;
- (void)ProgressViewWithValueForFormRows:(float)aProgressValue;
- (void)ProgressViewWithValueForWholeSalers:(float)aProgressValue;
- (void)ProgressViewWithValueForDescriptionType:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedContacts:(float)aProgressValue;
- (void)ProgressViewWithValueForContact:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedConLocLink:(float)aProgressValue;
- (void)ProgressViewWithValueForConLocLink:(float)aProgressValue;
- (void)ProgressViewWithValueForPresenter:(float)aProgressValue;
- (void)ProgressViewWithValueForPaginatedImage:(float)aProgressValue;
- (void)ProgressViewWithValueForImage:(float)aProgressValue;
- (void)ProgressViewWithValueForEmployee:(float)aProgressValue;
- (void)ProgressViewWithValueForConfig:(float)aProgressValue;
- (void)ProgressViewWithValueForOrder:(float)aProgressValue;
- (void)ProgressViewWithValueForCall:(float)aProgressValue;
- (void)ProgressViewWithValueForResponse:(float)aProgressValue;
- (void)ProgressViewWithValueForSurvey:(float)aProgressValue;
- (void)ProgressViewWithValueForJourney:(float)aProgressValue;
- (void)ProgressViewWithValueForResources:(float)aProgressValue;

@end

@interface UpdateCenter : NSObject <WebServiceSharedClassDelegate>{
    WebServiceSharedClass* serviceClass;
    NSMutableArray* selectors;
    int _selectorsCount;
    NSString* currentSelectorName;
    
    NSTimer* performTimer;
    NSDate* _calculateBeginDate;
    NSDate* _calculateEndDate;
    int timeoutInterval;
    int totalTimeUsed;
    BOOL isBusy;
    
    //delegate
    id<UpdateCenterDelegate>delegate;
    NSDate* _orderStartDate;
    NSDate* _orderEndDate;
    NSDate* _callStartDate;
    NSDate* _callEndDate;
    NSDate* _responseStartDate;
    NSDate* _responseEndDate;
}
@property(nonatomic,retain)    NSMutableArray* selectors;
@property(nonatomic,assign) int selectorsCount;
@property(nonatomic,retain)    WebServiceSharedClass* serviceClass;
@property(nonatomic,retain)    NSTimer* performTimer;
@property(nonatomic,retain) NSDate* calculateBeginDate;
@property(nonatomic,retain) NSDate* calculateEndDate;
@property(nonatomic,retain)  NSString* currentSelectorName;

@property(nonatomic,assign)    id<UpdateCenterDelegate>delegate;
@property(nonatomic,retain) NSDate* orderStartDate;
@property(nonatomic,retain) NSDate* orderEndDate;
@property(nonatomic,retain) NSDate* callStartDate;
@property(nonatomic,retain) NSDate* callEndDate;
@property(nonatomic,retain) NSDate* responseStartDate;
@property(nonatomic,retain) NSDate* responseEndDate;

//-(void)pushSelector:(SEL)aSelector;
-(SEL)popSelector;
-(void)pushSelector:(SEL)aSelector withName:(NSString*)aName;
-(void)startPreformSelectors;
-(void)removeSelectorWithName:(NSString*)aName;
-(void)removeAllSelectors;
@end
