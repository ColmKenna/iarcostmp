//
//  GlobalSharedClass.h
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"
#import <CoreLocation/CoreLocation.h>
#import "math.h"
typedef enum {
    DateToday = 0,
    DateDay,
    DateThisWeek,
    DateWeek,
    DateThisMonth,
    DateMonth,
    DateYear,
    DateMat
} DateType;
@interface GlobalSharedClass : NSObject {
    NSMutableArray* testingCustomers;
    NSMutableArray* customerDetails;
    NSMutableDictionary* customerGroup;
    
    NSMutableArray* custLocations;
    NSMutableArray* customers;
    
    NSMutableArray* latitudes;
    NSMutableArray* longitudes;
    
    int increamentNumber;
    
    //NSMutableDictionary* appSetting;
    //global itmes//
    NSMutableDictionary* currentSelectedLocation;
    NSNumber* currentSelectedLocationIUR;
    NSNumber* _currentSelectedOrderLocationIUR;
    NSNumber* _currentSelectedPresenterLocationIUR;
    NSNumber* _currentSelectedCallLocationIUR;
    NSNumber* _currentSelectedSurveyLocationIUR;
    NSNumber* _currentSelectedContactIUR;
    
    //temp order form controller
    UIViewController* orderFormViewController;
    
    double serviceTimeoutInterval;
    double _reporterServiceTimeoutInterval;
    double _defaultServiceTimeoutInterval;
    int tag4RemovedRootSubview;
    NSString* dateFormat;
    NSString* datetimeFormat;
    NSString* datetimehmFormat;
    NSString* _dateHyphenFormat;
    NSString* _hourMinuteFormat;
    NSString* _utcDatetimeFormat;
    NSString* _datetimeCalendarFormat;
    NSString* _utcDateFormat;
    NSString* _stdUtcDateTimeFormat;
    NSString* _ieTimeZone;
    CGSize orderPadsSize;
    NSString* _noDataFoundMsg;
    int pageSize;
    int imagePageSize;
    int batchedSize;
    int _responsePageSize;
    NSString* _packageSelectorName;
    NSString* _locationSelectorName;
    NSString* _locLocLinkSelectorName;
    NSString* _productSelectorName;
    NSString* _priceSelectorName;
    NSString* _descrDetailSelectorName;
    NSString* _descrTypeSelectorName;
    NSString* _presenterSelectorName;
    NSString* _imageSelectorName;
    NSString* _contactSelectorName;
    NSString* _conLocLinkSelectorName;
    NSString* _formDetailSelectorName;
    NSString* _formRowSelectorName;
    NSString* _employeeSelectorName;
    NSString* _configSelectorName;
    NSString* _orderHeaderSelectorName;
    NSString* _callOrderHeaderSelectorName;
    NSString* _surveySelectorName;
    NSString* _journeySelectorName;
    NSString* _resourcesSelectorName;
    NSString* _responseSelectorName;
    NSString* _locationProductMATSelectorName;
    NSString* _collectedSelectorName;
    NSString* _currentSelectorName;
    NSNumber* _lastOrderFormIUR;
    NSString* _defaultCellImageName;
    
    NSNumber* _locationDefaultImageIUR;
    NSNumber* _contactDefaultImageIUR;
    NSNumber* _employeeDefaultImageIUR;
    NSNumber* _journeyDefaultImageIUR;
    NSNumber* _wholesalerDefaultImageIUR;
    NSString* _unassignedText;
    float _imageCellAlpha;
    
    NSString* _cancelButtonText;
    NSString* _backButtonText;
    NSString* _saveButtonText;
    
    int _customerRefMaxLength;
    int _memoDetailMaxLength;
    float _slideUpViewHeight;
    NSNumber* _formRowFormTypeNumber;
    NSString* _unknownText;
    NSString* _accountNoText;
    float _mainMasterWidth;
    NSString* _customerText;
    NSString* _contactText;
    NSString* _listingsText;
    CGPoint _titleDisplacement;
    CGPoint _analysisTitleDisplacement;
    CGSize _numberPadSize;
    NSString* _errorTitle;
    NSString* _appImageName;
    NSString* _rowDelimiter;
    NSString* _fieldDelimiter;
    int _callEntrySelectionBoxLength;
    NSString* _vansCode;
    int _popoverMinimumWidth;
    int _popoverMediumWidth;
    int _popoverLargeWidth;
    int _popoverMaximumWidth;
    int _deliveryInstructions1MaxLength;
    NSString* _ieLocale;
    int _mailTimeout;
    NSString* _tildeDelimiter;
    NSString* _issuesText;
    NSString* _pxDbName;
    NSDate* _startRecordingDate;
    int _blockedLevel;
    int _mandatoryLevel;
    int _remindLevel;
    NSString* _myDbName;
    NSString* _acctNoCompany;
    UIColor* _myAppBlueColor;
    UIColor* _mySystemBlueColor;
    NSMutableDictionary* _currentSelectedPackage;
}

+(GlobalSharedClass*)shared;

@property (nonatomic,retain)     NSMutableArray* testingCustomers;
@property (nonatomic,retain)     NSMutableArray* customerDetails;
@property (nonatomic,retain)     NSMutableDictionary* customerGroup;
@property (nonatomic,retain)     NSMutableArray* custLocations;
@property (nonatomic,retain)     NSMutableArray* customers;
@property (nonatomic,retain)     NSMutableArray* latitudes;
@property (nonatomic,retain)     NSMutableArray* longitudes;

@property (nonatomic,assign)     int increamentNumber;
//@property (nonatomic,retain)     NSMutableDictionary* appSetting;

 //global itmes//
@property (nonatomic,retain)     NSMutableDictionary* currentSelectedLocation;
@property (nonatomic,retain)     NSNumber* currentSelectedLocationIUR;
@property (nonatomic,retain) NSNumber* currentSelectedOrderLocationIUR;
@property (nonatomic,retain) NSNumber* currentSelectedPresenterLocationIUR;
@property (nonatomic,retain) NSNumber* currentSelectedCallLocationIUR;
@property (nonatomic,retain) NSNumber* currentSelectedSurveyLocationIUR;
@property (nonatomic,retain) NSNumber* currentSelectedContactIUR;

@property (nonatomic,retain)     UIViewController* orderFormViewController;
@property (nonatomic,assign) double serviceTimeoutInterval;
@property (nonatomic,assign) double reporterServiceTimeoutInterval;
@property (nonatomic,assign) double defaultServiceTimeoutInterval;
@property (nonatomic,assign) int tag4RemovedRootSubview;
@property (nonatomic,retain) NSString* dateFormat;
@property (nonatomic,retain) NSString* datetimeFormat;
@property (nonatomic,retain) NSString* datetimehmFormat;
@property (nonatomic,retain) NSString* dateHyphenFormat;
@property (nonatomic,retain) NSString* hourMinuteFormat;
@property (nonatomic,retain) NSString* utcDatetimeFormat;
@property (nonatomic,retain) NSString* datetimeCalendarFormat;
@property (nonatomic,retain) NSString* utcDateFormat;
@property (nonatomic,retain) NSString* stdUtcDateTimeFormat;
@property (nonatomic,retain) NSString* ieTimeZone;
@property (nonatomic,assign) CGSize orderPadsSize;
@property (nonatomic,retain) NSString* noDataFoundMsg;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,assign) int imagePageSize;
@property (nonatomic,assign) int batchedSize;
@property (nonatomic,assign) int responsePageSize;

@property (nonatomic, retain) NSString* packageSelectorName;
@property (nonatomic, retain) NSString* locationSelectorName;
@property (nonatomic, retain) NSString* locLocLinkSelectorName;
@property (nonatomic, retain) NSString* productSelectorName;
@property (nonatomic, retain) NSString* priceSelectorName;
@property (nonatomic, retain) NSString* descrDetailSelectorName;
@property (nonatomic, retain) NSString* descrTypeSelectorName;
@property (nonatomic, retain) NSString* presenterSelectorName;
@property (nonatomic, retain) NSString* imageSelectorName;
@property (nonatomic, retain) NSString* contactSelectorName;
@property (nonatomic, retain) NSString* conLocLinkSelectorName;
@property (nonatomic, retain) NSString* formDetailSelectorName;
@property (nonatomic, retain) NSString* formRowSelectorName;
@property (nonatomic, retain) NSString* employeeSelectorName;
@property (nonatomic, retain) NSString* configSelectorName;
@property (nonatomic, retain) NSString* orderHeaderSelectorName;
@property (nonatomic, retain) NSString* callOrderHeaderSelectorName;
@property (nonatomic, retain) NSString* surveySelectorName;
@property (nonatomic, retain) NSString* journeySelectorName;
@property (nonatomic, retain) NSString* resourcesSelectorName;
@property (nonatomic, retain) NSString* responseSelectorName;
@property (nonatomic, retain) NSString* locationProductMATSelectorName;
@property (nonatomic, retain) NSString* collectedSelectorName;
@property (nonatomic, retain) NSString* currentSelectorName;
@property (nonatomic, retain) NSNumber* lastOrderFormIUR;
@property (nonatomic, retain) NSString* defaultCellImageName;
@property (nonatomic, retain) NSNumber* locationDefaultImageIUR;
@property (nonatomic, retain) NSNumber* contactDefaultImageIUR;
@property (nonatomic, retain) NSNumber* employeeDefaultImageIUR;
@property (nonatomic, retain) NSNumber* journeyDefaultImageIUR;
@property (nonatomic, retain) NSNumber* wholesalerDefaultImageIUR;
@property (nonatomic, retain) NSString* unassignedText;
@property (nonatomic, assign) float imageCellAlpha;
@property (nonatomic,retain) NSString* cancelButtonText;
@property (nonatomic,retain) NSString* backButtonText;
@property (nonatomic,retain) NSString* saveButtonText;
@property (nonatomic,assign) int customerRefMaxLength;
@property (nonatomic,assign) int memoDetailMaxLength;
@property (nonatomic,assign) float slideUpViewHeight;
@property (nonatomic,retain) NSNumber* formRowFormTypeNumber;
@property (nonatomic,retain) NSString* unknownText;
@property (nonatomic,retain) NSString* accountNoText;
@property (nonatomic,assign) float mainMasterWidth;
@property (nonatomic,retain) NSString* customerText;
@property (nonatomic,retain) NSString* contactText;
@property (nonatomic,retain) NSString* listingsText;
@property (nonatomic,assign) CGPoint titleDisplacement;
@property (nonatomic,assign) CGPoint analysisTitleDisplacement;
@property (nonatomic,assign) CGSize numberPadSize;
@property (nonatomic,retain) NSString* errorTitle;
@property (nonatomic,retain) NSString* appImageName;
@property (nonatomic,retain) NSString* rowDelimiter;
@property (nonatomic,retain) NSString* fieldDelimiter;
@property (nonatomic,assign) int callEntrySelectionBoxLength;
@property (nonatomic,retain) NSString* vansCode;
@property (nonatomic,assign) int popoverMinimumWidth;
@property (nonatomic,assign) int popoverMediumWidth;
@property (nonatomic,assign) int popoverLargeWidth;
@property (nonatomic,assign) int popoverMaximumWidth;
@property (nonatomic,assign) int deliveryInstructions1MaxLength;
@property (nonatomic,retain) NSString* ieLocale;
@property (nonatomic,assign) int mailTimeout;
@property (nonatomic,retain) NSString* tildeDelimiter;
@property (nonatomic,retain) NSString* issuesText;
@property (nonatomic,retain) NSString* pxDbName;
@property (nonatomic,retain) NSDate* startRecordingDate;
@property (nonatomic,assign) int blockedLevel;
@property (nonatomic,assign) int mandatoryLevel;
@property (nonatomic,assign) int remindLevel;
@property (nonatomic,retain) NSString* myDbName;
@property (nonatomic,retain) NSString* acctNoCompany;
@property (nonatomic,retain) UIColor* myAppBlueColor;
@property (nonatomic,retain) UIColor* mySystemBlueColor;
@property (nonatomic,retain) NSMutableDictionary* currentSelectedPackage;

//usful functions
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;
- (NSNumber*)randomIntBetween:(int)min and:(int)max;
- (NSNumber*)nextIncreamentNumber;
-(BOOL)isNumeric:(NSString*)inputString;

-(CLLocationCoordinate2D) NewLocationFrom:(CLLocationCoordinate2D)startingPoint 
                       atDistanceInMeters:(float)distanceInMeters
                    alongBearingInDegrees:(double)bearingInDegrees;
-(CGRect)boundRectFromStartPoint:(CLLocationCoordinate2D)sPoint withDistance:(float)distance;

//calender funtions
-(NSDate*)today;
-(NSDate*)thisWeek;
-(NSDate*)lastWeek;
-(NSDate*)thisMonth;
-(NSDate*)lastMonth;
-(NSDate*)thisYear;
-(NSDate*)thisMat;
-(NSDate*)dateByOffsetToday:(NSInteger)days;
-(NSDate*)dateFor:(DateType)dateType offset:(int)offset;
-(NSNumber*)currentTimeStamp;
-(NSMutableDictionary*)createUnAssignedContact;
//app setting
//-(void)increaseOrderNumber;
-(NSString*)currentPasscode;
- (NSMutableDictionary*)retrieveCurrentSelectedPackage;
@end
