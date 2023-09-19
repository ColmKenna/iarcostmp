//
//  GlobalSharedClass.m
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "GlobalSharedClass.h"
#import "ArcosCoreData.h"

@implementation GlobalSharedClass

static GlobalSharedClass* _shared = nil;

@synthesize testingCustomers;
@synthesize customerDetails;
@synthesize customerGroup;
@synthesize custLocations;
@synthesize customers;

@synthesize latitudes;
@synthesize longitudes;

@synthesize increamentNumber;
//@synthesize appSetting;
//global itmes//
@synthesize currentSelectedLocation;
@synthesize currentSelectedLocationIUR;
@synthesize currentSelectedOrderLocationIUR = _currentSelectedOrderLocationIUR;
@synthesize currentSelectedPresenterLocationIUR = _currentSelectedPresenterLocationIUR;
@synthesize currentSelectedCallLocationIUR = _currentSelectedCallLocationIUR;
@synthesize currentSelectedSurveyLocationIUR = _currentSelectedSurveyLocationIUR;
@synthesize currentSelectedContactIUR = _currentSelectedContactIUR;

@synthesize orderFormViewController;
@synthesize serviceTimeoutInterval;
@synthesize reporterServiceTimeoutInterval = _reporterServiceTimeoutInterval;
@synthesize defaultServiceTimeoutInterval = _defaultServiceTimeoutInterval;
@synthesize tag4RemovedRootSubview;
@synthesize dateFormat;
@synthesize datetimeFormat;
@synthesize datetimehmFormat;
@synthesize dateHyphenFormat = _dateHyphenFormat;
@synthesize hourMinuteFormat = _hourMinuteFormat;
@synthesize utcDatetimeFormat = _utcDatetimeFormat;
@synthesize datetimeCalendarFormat = _datetimeCalendarFormat;
@synthesize utcDateFormat = _utcDateFormat;
@synthesize stdUtcDateTimeFormat = _stdUtcDateTimeFormat;
@synthesize stdDateTimeFormat = _stdDateTimeFormat;
@synthesize ieTimeZone = _ieTimeZone;
@synthesize orderPadsSize;
@synthesize noDataFoundMsg = _noDataFoundMsg;
@synthesize pageSize;
@synthesize imagePageSize;
@synthesize batchedSize;
@synthesize responsePageSize = _responsePageSize;
@synthesize packageSelectorName = _packageSelectorName;
@synthesize locationSelectorName = _locationSelectorName;
@synthesize locLocLinkSelectorName = _locLocLinkSelectorName;
@synthesize productSelectorName = _productSelectorName;
@synthesize priceSelectorName = _priceSelectorName;
@synthesize descrDetailSelectorName = _descrDetailSelectorName;
@synthesize descrTypeSelectorName = _descrTypeSelectorName;
@synthesize presenterSelectorName = _presenterSelectorName;
@synthesize imageSelectorName = _imageSelectorName;
@synthesize contactSelectorName = _contactSelectorName;
@synthesize conLocLinkSelectorName = _conLocLinkSelectorName;
@synthesize formDetailSelectorName = _formDetailSelectorName;
@synthesize formRowSelectorName = _formRowSelectorName;
@synthesize employeeSelectorName = _employeeSelectorName;
@synthesize configSelectorName = _configSelectorName;
@synthesize orderHeaderSelectorName = _orderHeaderSelectorName;
@synthesize callOrderHeaderSelectorName = _callOrderHeaderSelectorName;
@synthesize surveySelectorName = _surveySelectorName;
@synthesize journeySelectorName = _journeySelectorName;
@synthesize resourcesSelectorName = _resourcesSelectorName;
@synthesize responseSelectorName = _responseSelectorName;
@synthesize locationProductMATSelectorName = _locationProductMATSelectorName;
@synthesize collectedSelectorName = _collectedSelectorName;
@synthesize currentSelectorName = _currentSelectorName;
@synthesize lastOrderFormIUR = _lastOrderFormIUR;
@synthesize defaultCellImageName = _defaultCellImageName;
@synthesize locationDefaultImageIUR = _locationDefaultImageIUR;
@synthesize contactDefaultImageIUR = _contactDefaultImageIUR;
@synthesize employeeDefaultImageIUR = _employeeDefaultImageIUR;
@synthesize journeyDefaultImageIUR = _journeyDefaultImageIUR;
@synthesize wholesalerDefaultImageIUR = _wholesalerDefaultImageIUR;
@synthesize unassignedText = _unassignedText;
@synthesize imageCellAlpha = _imageCellAlpha;
@synthesize cancelButtonText = _cancelButtonText;
@synthesize backButtonText = _backButtonText;
@synthesize saveButtonText = _saveButtonText;

@synthesize customerRefMaxLength = _customerRefMaxLength;
@synthesize memoDetailMaxLength = _memoDetailMaxLength;
@synthesize slideUpViewHeight = _slideUpViewHeight;
@synthesize formRowFormTypeNumber = _formRowFormTypeNumber;
@synthesize unknownText = _unknownText;
@synthesize accountNoText = _accountNoText;
@synthesize mainMasterWidth = _mainMasterWidth;
@synthesize customerText = _customerText;
@synthesize contactText = _contactText;
@synthesize listingsText = _listingsText;
@synthesize titleDisplacement = _titleDisplacement;
@synthesize analysisTitleDisplacement = _analysisTitleDisplacement;
@synthesize numberPadSize = _numberPadSize;
@synthesize errorTitle = _errorTitle;
@synthesize appImageName = _appImageName;
@synthesize rowDelimiter = _rowDelimiter;
@synthesize fieldDelimiter = _fieldDelimiter;
@synthesize commaDelimiter = _commaDelimiter;
@synthesize callEntrySelectionBoxLength = _callEntrySelectionBoxLength;
@synthesize vansCode = _vansCode;
@synthesize popoverMinimumWidth = _popoverMinimumWidth;
@synthesize popoverMediumWidth = _popoverMediumWidth;
@synthesize popoverLargeWidth = _popoverLargeWidth;
@synthesize popoverMaximumWidth = _popoverMaximumWidth;
@synthesize deliveryInstructions1MaxLength = _deliveryInstructions1MaxLength;
@synthesize ieLocale = _ieLocale;
@synthesize mailTimeout = _mailTimeout;
@synthesize tildeDelimiter = _tildeDelimiter;
@synthesize issuesText = _issuesText;
@synthesize pxDbName = _pxDbName;
@synthesize startRecordingDate = _startRecordingDate;
@synthesize blockedLevel = _blockedLevel;
@synthesize mandatoryLevel = _mandatoryLevel;
@synthesize remindLevel = _remindLevel;
@synthesize myDbName = _myDbName;
@synthesize acctNoCompany = _acctNoCompany;
@synthesize myAppBlueColor = _myAppBlueColor;
@synthesize mySystemBlueColor = _mySystemBlueColor;
//@synthesize currentSelectedPackage = _currentSelectedPackage;
@synthesize currentSelectedPackageIUR = _currentSelectedPackageIUR;
@synthesize packageViewCount = _packageViewCount;
@synthesize noMailAcctMsg = _noMailAcctMsg;
@synthesize noMailAcctTitle = _noMailAcctTitle;

+(GlobalSharedClass*)shared 
{
	@synchronized([GlobalSharedClass class])
	{
		if (!_shared)
			[[self alloc] init];
        
		return _shared;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([GlobalSharedClass class])
	{
		NSAssert(_shared == nil, @"Attempted to allocate a second instance of a singleton.");
		_shared = [super alloc];
		return _shared;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
//		self.appSetting=[NSMutableDictionary dictionary];
//        [appSetting setObject:[NSNumber numberWithInt:217] forKey:@"WholesalerTypeIUR"];
//        [appSetting setObject:[NSNumber numberWithInt:229] forKey:@"PendingOrderIUR"];
//        [appSetting setObject:[NSNumber numberWithInt:239] forKey:@"OrderTypeIUR"];
//        [appSetting setObject:[NSNumber numberWithInt:164] forKey:@"CallTypeIUR"];
//        [appSetting setObject:[NSNumber numberWithInt:228] forKey:@"MemoTypeIUR"];
//        [appSetting setObject:[NSNumber numberWithBool:NO] forKey:@"NeedInactiveRecord"];
//        [appSetting setObject:[NSNumber numberWithInt:8] forKey:@"DefaultFormIUR"];
//        [appSetting setObject:@"http://www.stratait.ie/downloads/" forKey:@"DownloadServer"];
//        [appSetting setObject:@"http://www.strataarcos.com/copydataservice/service.asmx" forKey:@"WebServiceServer"];
//        [appSetting setObject:[NSNumber numberWithInt:88888] forKey:@"EmployeeIUR"];

        //self.appSetting=[[ArcosCoreData sharedArcosCoreData]getSetting];
        increamentNumber=0;
        self.serviceTimeoutInterval = 60.0;
        self.reporterServiceTimeoutInterval = 90.0;
        self.defaultServiceTimeoutInterval = 60.0;
        self.tag4RemovedRootSubview = 999999;
        self.dateFormat = @"dd/MM/yyyy";
        self.datetimeFormat = @"dd/MM/yyyy HH:mm:ss";
        self.datetimehmFormat = @"dd/MM/yyyy HH:mm";
        self.dateHyphenFormat = @"dd-MM-yyyy";
        self.hourMinuteFormat = @"HH:mm";
        self.utcDatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        self.datetimeCalendarFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSS";
        self.utcDateFormat = @"yyyy-MM-dd";
        self.stdUtcDateTimeFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        self.stdDateTimeFormat = @"yyyy-MM-dd HH:mm:ss";
        self.ieTimeZone = @"Europe/Dublin";
        self.orderPadsSize = CGSizeMake(380.0f, 700.0f);
        self.noDataFoundMsg = @"No data found";
        self.pageSize = 100;
        self.imagePageSize = 1;
        self.batchedSize = 3000;
        self.responsePageSize = 100;
        self.packageSelectorName = @"Package";
        self.locationSelectorName = @"Location";
        self.locLocLinkSelectorName = @"LocLocLink";
        self.productSelectorName = @"Product";
        self.priceSelectorName = @"Price";
        self.descrDetailSelectorName = @"DescrDetail";
        self.descrTypeSelectorName = @"DescrType";
        self.presenterSelectorName = @"Presenter";
        self.imageSelectorName = @"Image";
        self.contactSelectorName = @"Contact";
        self.conLocLinkSelectorName = @"ConLocLink";
        self.formDetailSelectorName = @"FormDetail";
        self.formRowSelectorName = @"FormRow";
        self.employeeSelectorName = @"Employee";
        self.configSelectorName = @"Config";
        self.orderHeaderSelectorName = @"OrderHeader";
        self.callOrderHeaderSelectorName = @"Call";
        self.surveySelectorName = @"Survey";
        self.journeySelectorName = @"Journey";
        self.resourcesSelectorName = @"Resources";
        self.responseSelectorName = @"Response";
        self.locationProductMATSelectorName = @"LocationProductMAT";
        self.collectedSelectorName = @"Collected";
        self.defaultCellImageName = @"bullet_white.png";
        self.locationDefaultImageIUR = [NSNumber numberWithInt:101];
        self.contactDefaultImageIUR = [NSNumber numberWithInt:102];
        self.employeeDefaultImageIUR = [NSNumber numberWithInt:103];
        self.journeyDefaultImageIUR = [NSNumber numberWithInt:115];
        self.wholesalerDefaultImageIUR = [NSNumber numberWithInt:117];
        self.unassignedText = @"UnAssigned";
        self.imageCellAlpha = 0.5f;
        self.cancelButtonText = @"Cancel";
        self.backButtonText = @"Back";
        self.saveButtonText = @"Save";
        self.customerRefMaxLength = 30;
        self.memoDetailMaxLength = 8000;
        self.slideUpViewHeight = 116.0f;
        self.formRowFormTypeNumber = [NSNumber numberWithInt:305];
        self.unknownText = @"*UnKnown*";
        self.accountNoText = @"Account No.";
        self.mainMasterWidth = 64.0f;
        self.customerText = @"Location";
        self.contactText = @"Contact";
        self.listingsText = @"Listings";
        self.titleDisplacement = CGPointMake(0.0, 12.0);
        self.analysisTitleDisplacement = CGPointMake(0.0, -7.0);
        self.numberPadSize = CGSizeMake(470.0, 287.0);
        self.errorTitle = @"Error !";
        self.appImageName = @"Arcos-Icon-2a-setting@2x.png";
        self.rowDelimiter = @"\r\n";
        self.fieldDelimiter = @"|";
        self.commaDelimiter = @",";
        self.callEntrySelectionBoxLength = 30;
        self.vansCode = @"VANS";
        self.popoverMinimumWidth = 9;
        self.popoverMediumWidth = 18;
        self.popoverLargeWidth = 28;
        self.popoverMaximumWidth = 38;
        self.deliveryInstructions1MaxLength = 100;
        self.ieLocale = @"en_IE";
        self.mailTimeout = 150;
        self.tildeDelimiter = @"~";
        self.issuesText = @"Issues";
        self.pxDbName = @"PX19";
        self.blockedLevel = 90;
        self.mandatoryLevel = 80;
        self.remindLevel = 70;
        self.myDbName = @"MY10";
        self.acctNoCompany = @"uniphar";
        self.myAppBlueColor = [UIColor colorWithRed:0.0 green:150.0/255.0 blue:214.0/255.0 alpha:1.0];
        self.mySystemBlueColor = [UIColor colorWithRed:0.0 green:132.0/255.0 blue:254.0/255.0 alpha:1.0];
        self.packageViewCount = 0;
        self.noMailAcctMsg = @"Please set up a Mail account in order to send email";
        self.noMailAcctTitle = @"No Mail Account";
	}
    
	return self;
}

//global methods
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
- (NSNumber*)randomIntBetween:(int)min and:(int)max{
    //NSNumber* theNumber=[NSNumber numberWithInt: arc4random() % min + (max-min)];
    NSNumber* theNumber= [NSNumber numberWithInt:(arc4random() % (max - min)+ min)];
    return theNumber;
}

- (NSNumber*)nextIncreamentNumber{
    return [NSNumber numberWithInt:increamentNumber++];
}
-(BOOL)isNumeric:(NSString*)inputString{
    if ([inputString isEqualToString:@""]||inputString==nil) {
        return NO;
    }
    
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

//end point calculation
CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};
-(CLLocationCoordinate2D) NewLocationFrom:(CLLocationCoordinate2D)startingPoint 
                         atDistanceInMeters:(float)distanceInMeters
                     alongBearingInDegrees:(double)bearingInDegrees {
    
    double lat1 = DegreesToRadians(startingPoint.latitude);
    double lon1 = DegreesToRadians(startingPoint.longitude);
    
    double a = 6378137, b = 6356752.3142, f = 1/298.257223563;  // WGS-84 ellipsiod
    double s = distanceInMeters;
    double alpha1 = DegreesToRadians(bearingInDegrees);
    double sinAlpha1 = sin(alpha1);
    double cosAlpha1 = cos(alpha1);
    
    double tanU1 = (1 - f) * tan(lat1);
    double cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
    double sinU1 = tanU1 * cosU1;
    double sigma1 = atan2(tanU1, cosAlpha1);
    double sinAlpha = cosU1 * sinAlpha1;
    double cosSqAlpha = 1 - sinAlpha * sinAlpha;
    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    
    double sigma = s / (b * A);
    double sigmaP = 2 * M_PI;
    
    double cos2SigmaM;
    double sinSigma;
    double cosSigma;
    
    while (abs(sigma - sigmaP) > 1e-12) {
        cos2SigmaM = cos(2 * sigma1 + sigma);
        sinSigma = sin(sigma);
        cosSigma = cos(sigma);
        double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
        sigmaP = sigma;
        sigma = s / (b * A) + deltaSigma;
    }
    
    double tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
    double lat2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1, (1 - f) * sqrt(sinAlpha * sinAlpha + tmp * tmp));
    double lambda = atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
    double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    double L = lambda - (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    
    double lon2 = lon1 + L;
    
    // Create a new CLLocationCoordinate2D for this point
    CLLocationCoordinate2D edgePoint = CLLocationCoordinate2DMake(RadiansToDegrees(lat2), RadiansToDegrees(lon2));
    
    return edgePoint;
}
-(CGRect)boundRectFromStartPoint:(CLLocationCoordinate2D)sPoint withDistance:(float)distance{
    //              points in graph
    //
    //             ------ a ------
    //             |       | <-distance
    //             |       |     |
    //             d   sPoint    b
    //             |             |
    //             |             |  <-bound box retured
    //             ------ c ------
    //
    //
    
    CLLocationCoordinate2D a=[self NewLocationFrom:sPoint atDistanceInMeters:distance alongBearingInDegrees:0];
    CLLocationCoordinate2D b=[self NewLocationFrom:sPoint atDistanceInMeters:distance alongBearingInDegrees:90];
    CLLocationCoordinate2D c=[self NewLocationFrom:sPoint atDistanceInMeters:distance alongBearingInDegrees:180];
    CLLocationCoordinate2D d=[self NewLocationFrom:sPoint atDistanceInMeters:distance alongBearingInDegrees:270];
    
    CGRect theBoundRect= CGRectMake(a.latitude, d.longitude, b.longitude-d.longitude, c.latitude-a.latitude);
    NSLog(@"a---lat=%f  lon=%f",a.latitude,a.longitude);
    NSLog(@"b---lat=%f  lon=%f",b.latitude,b.longitude);
    NSLog(@"c---lat=%f  lon=%f",c.latitude,c.longitude);
    NSLog(@"d---lat=%f  lon=%f",d.latitude,d.longitude);

    
    return theBoundRect;
    
}
//finish end point calculation

//calender funtions
-(NSDate*)today{
    return [self dateFor:DateDay offset:0];
}
-(NSDate*)thisWeek{
    return [self dateFor:DateThisWeek offset:1];
}
-(NSDate*)lastWeek{
    return [self dateFor:DateWeek offset:-1];
}
-(NSDate*)thisMonth{
    return [self dateFor:DateThisMonth offset:1];
}
-(NSDate*)lastMonth{
    return [self dateFor:DateMonth offset:-1];
}
-(NSDate*)thisYear{
    return [self dateFor:DateYear offset:-1];
}
-(NSDate*)thisMat{
    return [self dateFor:DateMat offset:-1];
}
-(NSDate*)dateByOffsetToday:(NSInteger)days{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear
                fromDate:[NSDate date]];
    
    comps.day+=days;
    
    return [calendar dateFromComponents:comps];
}
-(NSDate*)dateFor:(DateType)dateType offset:(int)offset{
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]autorelease];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday
                fromDate:[NSDate date]];
    
    if(dateType == DateDay) {
        
        comps.day+=offset;
        comps.hour=1;
    }
    else if(dateType == DateThisWeek) {
        
        [comps setDay:([comps day]-([comps weekday]-2))];
        comps.hour=1;//not sure
    }
    else if(dateType == DateWeek) {
        
        comps.weekday = 1;
        comps.weekOfYear+=offset;
        comps.hour=1;

    }
    else if(dateType == DateThisMonth) {
        
        comps.day = 1;
        comps.hour=1;

    }
    else if(dateType == DateMonth) {
        
        comps.day = 1;
        comps.month+=offset;
        comps.hour=1;

    }
    else if(dateType == DateYear) {
        
        comps.day = 1;
        comps.month=1;
        //comps.year+=offset;
        comps.hour=1;

    }
    else if(dateType == DateMat) {
        comps.year+=offset;
        comps.hour = 1;
    }

    //NSLog(@"date range %@",[calendar dateFromComponents:comps]);
    return [calendar dateFromComponents:comps];

}
-(NSNumber*)currentTimeStamp{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
//    NSLog(@"time stamp is %f  intgervalue is %d",timeStamp,[timeStampObj intValue]);
    return [NSNumber numberWithUnsignedInt:[timeStampObj unsignedIntValue]];
}
-(NSMutableDictionary*)createUnAssignedContact {
    NSMutableDictionary* unAssignedContactDict = [[[NSMutableDictionary alloc] init] autorelease];
    [unAssignedContactDict setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
    [unAssignedContactDict setObject:@"UnAssigned" forKey:@"Title"];
    return unAssignedContactDict;
}
-(NSString*)currentPasscode {
    NSString* passcode = @"";
    @try {
        NSDate* todayDate = [NSDate date];
        NSString* sixDateString = [ArcosUtils stringFromDate:todayDate format:@"ddMMyy"];
        
        NSRange dayRange = NSMakeRange(0, 2);
        NSRange monthRange = NSMakeRange(2, 2);
        NSString* dayString = [sixDateString substringWithRange:dayRange];
        NSString* monthString = [sixDateString substringWithRange:monthRange];
        NSString* monthName = [ArcosUtils stringFromDate:todayDate format:@"MMMM"];
        
        
        NSNumber* dayNumber = [ArcosUtils convertStringToNumber:dayString];
        int finalDayNumber = [dayNumber intValue] + 55;
        
        NSMutableString* reversedMonthString = [NSMutableString string];
        NSInteger charIndex = [monthString length];
        while (charIndex > 0) {
            charIndex--;
            NSRange subStrRange = NSMakeRange(charIndex, 1);
            [reversedMonthString appendString:[monthString substringWithRange:subStrRange]];
        }
        NSDate* nextMonthDate = [ArcosUtils addMonths:1 date:todayDate];
        NSString* nextMonthName = [ArcosUtils stringFromDate:nextMonthDate format:@"MMMM"]; 
        
        NSString* firstLetterOfNextMonthName = [nextMonthName substringToIndex:1];
        NSString* lastLetterOfMonthName = [monthName substringFromIndex:[monthName length] - 1];
//        NSLog(@"sixDateString:%@:dayString:%@:monthString:%@:finalDayNumber:%d:reversedMonthString:%@:addOneMonthName:%@:monthName:%@:firstLetterOfNextMonthName:%@:lastLetterOfMonthName:%@", sixDateString,dayString,monthString,finalDayNumber,reversedMonthString,nextMonthName, monthName,firstLetterOfNextMonthName, lastLetterOfMonthName);
        passcode = [NSString stringWithFormat:@"%@%@%d%@",firstLetterOfNextMonthName,reversedMonthString,finalDayNumber,lastLetterOfMonthName];
//        NSLog(@"passcode: %@", passcode);
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    
    return passcode;
}

//- (NSMutableDictionary*)retrieveCurrentSelectedPackage {
//    if (self.currentSelectedPackage == nil) {
//        self.currentSelectedPackage = [[ArcosCoreData sharedArcosCoreData] retrieveDefaultPackageWithLocationIUR:self.currentSelectedLocationIUR];
//    }
//    return self.currentSelectedPackage;
//}
- (NSNumber*)retrieveCurrentSelectedPackageIURWithRequestSource:(ProductRequestSource)aRequestSource {
    if (self.currentSelectedPackageIUR == nil && aRequestSource == ProductRequestSourcePresenterSubMenu) {
        NSMutableDictionary* tmpDefaultPackage = [[ArcosCoreData sharedArcosCoreData] retrieveDefaultPackageWithLocationIUR:self.currentSelectedLocationIUR];
        self.currentSelectedPackageIUR = [tmpDefaultPackage objectForKey:@"iUR"];
    }
    return self.currentSelectedPackageIUR;
}

#pragma mark app setting

-(void)dealloc{    
    [testingCustomers release];
    [customerDetails release];
    [customerGroup release];
    [custLocations release];
    [customers release];
    [latitudes release];
    [longitudes release];
    self.currentSelectedLocation = nil;
    self.currentSelectedLocationIUR = nil;
    self.currentSelectedOrderLocationIUR = nil;
    self.currentSelectedPresenterLocationIUR = nil;
    self.currentSelectedCallLocationIUR = nil;
    self.currentSelectedSurveyLocationIUR = nil;
    self.currentSelectedContactIUR = nil;
    if (self.dateFormat != nil) { self.dateFormat = nil; }
    if (self.datetimeFormat != nil) { self.datetimeFormat = nil; }
    if (self.datetimehmFormat != nil) { self.datetimehmFormat = nil; }
    if (self.dateHyphenFormat != nil) { self.dateHyphenFormat = nil; }
    self.hourMinuteFormat = nil;
    self.utcDatetimeFormat = nil;
    self.datetimeCalendarFormat = nil;
    self.utcDateFormat = nil;
    self.stdUtcDateTimeFormat = nil;
    self.stdDateTimeFormat = nil;
    self.ieTimeZone = nil;
    if (self.noDataFoundMsg != nil) { self.noDataFoundMsg = nil; }
    self.packageSelectorName = nil;
    if (self.locationSelectorName != nil) { self.locationSelectorName = nil; }
    self.locLocLinkSelectorName = nil;
    if (self.productSelectorName != nil) { self.productSelectorName = nil; }
    self.priceSelectorName = nil;
    if (self.descrDetailSelectorName != nil) { self.descrDetailSelectorName = nil; }        
    if (self.descrTypeSelectorName != nil) { self.descrTypeSelectorName = nil; }            
    if (self.presenterSelectorName != nil) { self.presenterSelectorName = nil; }            
    if (self.imageSelectorName != nil) { self.imageSelectorName = nil; }                
    if (self.contactSelectorName != nil) { self.contactSelectorName = nil; }
    if (self.conLocLinkSelectorName != nil) { self.conLocLinkSelectorName = nil; }    
    if (self.formDetailSelectorName != nil) { self.formDetailSelectorName = nil; }
    if (self.formRowSelectorName != nil) { self.formRowSelectorName = nil; }
    if (self.employeeSelectorName != nil) { self.employeeSelectorName = nil; }    
    if (self.configSelectorName != nil) { self.configSelectorName = nil; }        
    if (self.orderHeaderSelectorName != nil) { self.orderHeaderSelectorName = nil; }
    if (self.callOrderHeaderSelectorName != nil) { self.callOrderHeaderSelectorName = nil; }            
    if (self.surveySelectorName != nil) { self.surveySelectorName = nil; }            
    if (self.journeySelectorName != nil) { self.journeySelectorName = nil; }
    if (self.resourcesSelectorName != nil) { self.resourcesSelectorName = nil; }
    self.responseSelectorName = nil;
    self.locationProductMATSelectorName = nil;
    self.collectedSelectorName = nil;
    if (self.currentSelectorName != nil) { self.currentSelectorName = nil; }
    if (self.lastOrderFormIUR != nil) { self.lastOrderFormIUR = nil; }
    if (self.defaultCellImageName != nil) { self.defaultCellImageName = nil; }
    if (self.locationDefaultImageIUR != nil) { self.locationDefaultImageIUR = nil; }
    if (self.contactDefaultImageIUR != nil) { self.contactDefaultImageIUR = nil; }
    if (self.employeeDefaultImageIUR != nil) { self.employeeDefaultImageIUR = nil; }
    if (self.journeyDefaultImageIUR != nil) { self.journeyDefaultImageIUR = nil; }
    if (self.wholesalerDefaultImageIUR != nil) { self.wholesalerDefaultImageIUR = nil; }    
    if (self.cancelButtonText != nil) { self.cancelButtonText = nil; }
    if (self.backButtonText != nil) { self.backButtonText = nil; }    
    if (self.saveButtonText != nil) { self.saveButtonText = nil; }
    if (self.formRowFormTypeNumber != nil) { self.formRowFormTypeNumber = nil; }
    self.unknownText = nil;
    self.accountNoText = nil;
    self.customerText = nil;
    self.contactText = nil;
    self.listingsText = nil;
    self.errorTitle = nil;
    self.appImageName = nil;
    self.rowDelimiter = nil;
    self.fieldDelimiter = nil;
    self.commaDelimiter = nil;
    self.vansCode = nil;
    self.ieLocale = nil;
    self.tildeDelimiter = nil;
    self.issuesText = nil;
    self.pxDbName = nil;
    self.startRecordingDate = nil;
    self.myDbName = nil;
    self.acctNoCompany = nil;
    self.myAppBlueColor = nil;
    self.mySystemBlueColor = nil;
//    self.currentSelectedPackage = nil;
    self.currentSelectedPackageIUR = nil;
    self.noMailAcctMsg = nil;
    self.noMailAcctTitle = nil;
    
    [super dealloc];
}
@end
