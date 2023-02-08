//
//  ArcosUtils.m
//  Arcos
//
//  Created by David Kilmartin on 08/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "ArcosUtils.h"
#import "ArcosAppDelegate_iPad.h"
#import "ArcosCoreData.h"

#ifndef NSFoundationVersionNumber_iOS_7_1
#define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif

@implementation ArcosUtils


+ (NSString*)convertNilToEmpty:(NSString*)aField {    
    return (aField == nil) ? @"" : aField;
}

+ (NSString*)convertDatetimeToDate:(NSString*)aField {
    if (aField != nil && aField.length > 10) {
        return [aField substringToIndex:10];
    }
    return aField;
}

+ (UIActivityIndicatorView*) initActivityIndicatorWithView:(UIView*)aView {
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = aView.center;
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[aView addSubview: activityIndicator];
    return activityIndicator;
}

+ (NSString*)convertToFloatString:(NSString*)aField {
    return [NSString stringWithFormat:@"%.2f", [aField floatValue]];
}

+ (NSString*)convertZeroToBlank:(NSString*)aField {
    return ([aField isEqualToString:@"0"] || [aField isEqualToString:@"0.00"]) ? @"" : aField;
}

+ (NSString*)convertBlankToZero:(NSString*)aField {
    return [aField isEqualToString:@""] ? @"0" : aField;
}

+ (NSString*)convertUnAssignedToBlank:(NSString*)aField {
    return [aField isEqualToString:[GlobalSharedClass shared].unassignedText] ? @"" : aField;
}

+ (void)showMsg:(int)errorCode message:(NSString*)message delegate:(id)delegate {
    NSString* titleMsg = (errorCode == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
    UIAlertView *v = [[UIAlertView alloc] initWithTitle: titleMsg message: message delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    [v show];
    [v release];
}

+ (void)showMsg:(NSString*)message title:(NSString*)title delegate:(id)delegate {
    UIAlertView *v = [[UIAlertView alloc] initWithTitle: title message: message delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    [v show];
    [v release];
}

+ (void)showMsg:(NSString*)message title:(NSString*)title delegate:(id)delegate tag:(int)aTag {
    UIAlertView* v = [[UIAlertView alloc] initWithTitle: title message: message delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    v.tag = aTag;
    [v show];
    [v release];
}

+ (void)showDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag handler:(void (^)(UIAlertAction* action))handler {
    if ([UIAlertController class]) {
        UIViewController* myArcosRootViewController = [self getRootView];
        UIAlertController* tmpDialogBox = [self createDialogBox:message title:title handler:handler];
        if (myArcosRootViewController.presentedViewController == nil) {
//            NSLog(@"a1");
            [myArcosRootViewController presentViewController:tmpDialogBox animated:YES completion:nil];
        } else if (aTarget != nil && aTarget.presentedViewController == nil) {
//            NSLog(@"a2");
            [aTarget presentViewController:tmpDialogBox animated:YES completion:nil];
        } else {
//            NSLog(@"a3");
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
            v.tag = aTag;
            [v show];
            [v release];
        }
    } else {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
        v.tag = aTag;
        [v show];
        [v release];
    }
}

+ (void)showTwoBtnsDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag lBtnText:(NSString*)lBtnText rBtnText:(NSString*)rBtnText lBtnHandler:(void (^)(UIAlertAction* action))lBtnHandler rBtnHandler:(void (^)(UIAlertAction* action))rBtnHandler {
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* lBtnAction = [UIAlertAction actionWithTitle:lBtnText style:UIAlertActionStyleDefault handler:lBtnHandler];
    [tmpDialogBox addAction:lBtnAction];
    UIAlertAction* rBtnAction = [UIAlertAction actionWithTitle:rBtnText style:UIAlertActionStyleDefault handler:rBtnHandler];
    [tmpDialogBox addAction:rBtnAction];
    UIViewController* myArcosRootViewController = [self getRootView];
    if (myArcosRootViewController.presentedViewController == nil) {
        [myArcosRootViewController presentViewController:tmpDialogBox animated:YES completion:nil];
    } else if (aTarget != nil && aTarget.presentedViewController == nil) {
        [aTarget presentViewController:tmpDialogBox animated:YES completion:nil];
    } else {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:lBtnText otherButtonTitles:rBtnText, nil];
        v.tag = aTag;
        [v show];
        [v release];
    }
}

+ (void)showThreeBtnsDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag lBtnText:(NSString*)lBtnText rBtnText:(NSString*)rBtnText thirdBtnText:(NSString*)thirdBtnText lBtnHandler:(void (^)(UIAlertAction* action))lBtnHandler rBtnHandler:(void (^)(UIAlertAction* action))rBtnHandler thirdBtnHandler:(void (^)(UIAlertAction* action))thirdBtnHandler {
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* lBtnAction = [UIAlertAction actionWithTitle:lBtnText style:UIAlertActionStyleDefault handler:lBtnHandler];
    [tmpDialogBox addAction:lBtnAction];
    UIAlertAction* rBtnAction = [UIAlertAction actionWithTitle:rBtnText style:UIAlertActionStyleDefault handler:rBtnHandler];
    [tmpDialogBox addAction:rBtnAction];
    UIAlertAction* thirdBtnAction = [UIAlertAction actionWithTitle:thirdBtnText style:UIAlertActionStyleDefault handler:thirdBtnHandler];
    [tmpDialogBox addAction:thirdBtnAction];
    UIViewController* myArcosRootViewController = [self getRootView];
    if (myArcosRootViewController.presentedViewController == nil) {
        [myArcosRootViewController presentViewController:tmpDialogBox animated:YES completion:nil];
    } else if (aTarget != nil && aTarget.presentedViewController == nil) {
        [aTarget presentViewController:tmpDialogBox animated:YES completion:nil];
    } else {
        
    }
}

+ (NSString*)convertToIntString:(NSString*)aField {
    return [NSString stringWithFormat:@"%d", [aField intValue]];
}

+ (NSString*)convertNumberToIntString:(NSNumber*)aNumber {
    return [NSString stringWithFormat:@"%d", [aNumber intValue]];
}

+ (NSObject*)convertNilDateToNull:(NSDate*)aDate {
    return (aDate == nil) ? [NSNull null] : aDate;
}

+ (void)showMsg:(NSString*)message delegate:(id)delegate {
    UIAlertView *v = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    [v show];
    [v release];
}

+ (NSString*)convertToString:(id)data {
    return [NSString stringWithFormat:@"%@", data];
}

+ (bool)checkFieldValue:(id)aFieldValue {
    if (aFieldValue == nil || [[NSString stringWithFormat:@"%@", aFieldValue] isEqualToString:@""] ) {
        return false;
    }
    return true;
}

+ (NSNumber*)convertStringToNumber:(NSString*)aField {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    [numberFormatter setLocale:ieLocale];
    [ieLocale release];
    NSNumber* myNumber = [NSNumber numberWithInt:[[numberFormatter numberFromString:aField] intValue]];
    [numberFormatter release];
    return myNumber;
}

+ (NSNumber*)convertStringToFloatNumber:(NSString*)aField {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    [numberFormatter setLocale:ieLocale];
    [ieLocale release];
    NSNumber* myNumber = [NSNumber numberWithFloat:[[numberFormatter numberFromString:aField] floatValue]];
    [numberFormatter release];
    return myNumber;
}

+ (NSDecimalNumber*)convertStringToDecimalNumber:(NSString*)aField {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    [numberFormatter setLocale:ieLocale];
    [ieLocale release];
    NSNumber* auxNumber = [numberFormatter numberFromString:aField];
    NSString* auxString = [numberFormatter stringFromNumber:auxNumber];
    NSNumber* finalNumber = [numberFormatter numberFromString:auxString];
    NSDecimalNumber* finalDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[finalNumber decimalValue]];
    [numberFormatter release];
    return finalDecimalNumber;
}

+ (NSString*)trim:(NSString*)aField {
    return [aField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)trimPipe:(NSString*)aField {
    return [aField stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
}

+ (NSString*)trim:(NSString*)aField characters:(NSString*)aCharacters {
    return [aField stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:aCharacters]];
}

+ (NSString*)convertIntToString:(int)aField {
    return [NSString stringWithFormat:@"%d", aField];
}

+ (NSString*)convertFloatToString:(float)aField {
    return [NSString stringWithFormat:@"%.2f", aField];
}

+ (unsigned int)convertNSUIntegerToUnsignedInt:(NSUInteger)aField {
    NSNumber* myNumber = [NSNumber numberWithUnsignedInteger:aField];
    return [myNumber unsignedIntValue];
}

+ (int)convertNSIntegerToInt:(NSInteger)aField {
    NSNumber* myNumber = [NSNumber numberWithInteger:aField];
    return [myNumber intValue];
}

+ (NSNumber*)convertNilToZero:(NSNumber*)aField {
    return aField == nil ? [NSNumber numberWithInt:0] : aField;
}

+ (NSDate*)todayWithFormat:(NSString*)dateFormat {
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:dateFormat];
    NSString* todayStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:todayStr];
}

+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)dateFormat {
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    NSLocale* ieLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_IE"] autorelease];
    [dateFormatter setLocale:ieLocale];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString*)convertNoneToEmpty:(NSString*)aField {
    return [aField isEqualToString:@"None"] ? @"" : aField;
}

+ (bool)checkFieldValueAndUnAssigned:(id)aFieldValue {
    if (aFieldValue == nil || [[NSString stringWithFormat:@"%@", aFieldValue] isEqualToString:@""] || [[NSString stringWithFormat:@"%@", aFieldValue] isEqualToString:@"UnAssigned"]) {
        return false;
    }
    return true;
}

+ (CGRect)correctViewFrame:(UIView*)rootView {
    // top: 2, bottom: 1, left: 4, right:3
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        NSLog(@"return landscape.");
        return CGRectMake(rootView.frame.origin.x, rootView.frame.origin.y, rootView.frame.size.height, rootView.frame.size.width);
    } 
    NSLog(@"return portrait.");
    return CGRectMake(rootView.frame.origin.x, rootView.frame.origin.y, rootView.frame.size.width, rootView.frame.size.height);   
}

+ (NSDate*)sundayOfWeek:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:aDate];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    NSInteger weekday = [weekdayComponents weekday];
//    NSLog(@"weekday %d", weekday);
    NSInteger numOfdays = 0;
    numOfdays = (weekday == 1) ? 0 : (8 - weekday);
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                                         toDate:aDate options:0];
}

+ (NSDate*)prevSunday:(NSDate*)aCurrentSundayDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    int numOfdays = -7;
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aCurrentSundayDate options:0];
}

+ (NSDate*)nextSunday:(NSDate*)aCurrentSundayDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    int numOfdays = 7;
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aCurrentSundayDate options:0];
}

+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat {
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    NSLocale* ieLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_IE"] autorelease];
    [dateFormatter setLocale:ieLocale];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:aDate];
}

+ (NSString*)weekDayNameFromDate:(NSDate*)aDate format:(NSString*)dateFormat {
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale* ieLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_IE"] autorelease];
    [dateFormatter setLocale:ieLocale];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:aDate];
}

+ (NSString*)stringFromFileSize:(NSNumber*)aFileSize {
    float theSize = [aFileSize floatValue];
    float floatSize = theSize;
    if (theSize<999)
        return([NSString stringWithFormat:@"%1.0f bytes",theSize]);
    floatSize = floatSize / 1000;
    if (floatSize<999)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1000;
    if (floatSize<999)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1000;
    
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

+ (NSString*)convertToString:(id)aFieldValue fieldType:(NSString*)aFieldType {
    if ([aFieldType isEqualToString:@"NSNumber"] || [aFieldType isEqualToString:@"NSDecimalNumber"]) {
        return [aFieldValue stringValue];
    }
    if ([aFieldType isEqualToString:@"NSString"]) {
        return aFieldValue;
    }
    if ([aFieldType isEqualToString:@"NSDate"]) {
        return [ArcosUtils stringFromDate:aFieldValue format:@"dd/MM/yyyy HH:mm:ss"];
    }
    if ([aFieldType isEqualToString:@"NSData"]) {
        return @"BLOB data";        
    }
    return aFieldType;    
}

+ (UIViewController*)getRootView {
    /*
    ArcosAppDelegate_iPad* arcosDelegate = [[UIApplication sharedApplication] delegate];
    return (UITabBarController*) arcosDelegate.mainTabbarController;
    */
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (NSNumber*)getDayOfWeekend {
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    return [configDict objectForKey:@"DayofWeekend"];
}

+ (NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend {
    //in sql server
    //0 or 7 stands for Sunday.
    //1 to 6 stand for Monday to Saturday
    //in objective c 1 to 7 stand for Sunday to Saturday
    if (aDayOfWeekend == 7) {
        aDayOfWeekend = 0;
    }
//    NSLog(@"aDayOfWeekend is %d", [ArcosUtils convertNSIntegerToInt:aDayOfWeekend]);
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:aDate];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    //in order to sync with the number in the sql server
    NSInteger weekday = [weekdayComponents weekday] - 1;
    NSInteger numOfdays = 0;
    if (weekday == aDayOfWeekend) {
        
    } else {
        numOfdays = (aDayOfWeekend == 0) ? (aDayOfWeekend - weekday + 7) : (aDayOfWeekend - weekday);
    }    
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)beginOfWeek:(NSDate*)aCurrentSundayDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    int numOfdays = -6;
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aCurrentSundayDate options:0];
}

+ (NSDate*)dateWithBeginOfWeek:(NSDate*)aBeginOfWeekDate interval:(NSInteger)anInterval {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
//    int numOfdays = 7;
    [componentsToAdd setDay:anInterval];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aBeginOfWeekDate options:0];
}

+ (NSDate*)beginDayOfMonth:(NSInteger)aMonthNumber withDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    
    [yearComponents setMonth:aMonthNumber];
    [yearComponents setDay:1];    
    [yearComponents setHour:1];
    [yearComponents setMinute:0];
    [yearComponents setSecond:0];
    return [gregorian dateFromComponents:yearComponents];    
}

+ (NSDate*)endDayOfMonth:(NSInteger)aMonthNumber withDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    
    [yearComponents setMonth:aMonthNumber];  
    NSDate* currentDate = [gregorian dateFromComponents:yearComponents];
    NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    [yearComponents setDay:monthRange.length];
    [yearComponents setHour:22];
    [yearComponents setMinute:59];
    [yearComponents setSecond:59];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSDate*)endDayOfYearWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];    
    [yearComponents setMonth:12];
    NSDate* currentDate = [gregorian dateFromComponents:yearComponents];
    NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    [yearComponents setDay:monthRange.length];
    [yearComponents setHour:22];
    [yearComponents setMinute:59];
    [yearComponents setSecond:59];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSDate*)beginOfDay:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];        
    [yearComponents setHour:1];
    [yearComponents setMinute:0];
    [yearComponents setSecond:0];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSDate*)beginOfDayWithZeroTime:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    [yearComponents setHour:0];
    [yearComponents setMinute:0];
    [yearComponents setSecond:0];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSDate*)endOfDay:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];        
    [yearComponents setHour:22];
    [yearComponents setMinute:59];
    [yearComponents setSecond:59];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSDate*)endOfDayWithMaxTime:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    [yearComponents setHour:23];
    [yearComponents setMinute:59];
    [yearComponents setSecond:59];
    return [gregorian dateFromComponents:yearComponents];
}

+ (NSInteger)weekDayWithDate:(NSDate*)aDate {
    //in objective c 1 to 7 stand for Sunday to Saturday
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:aDate];
    return [weekdayComponents weekday];
}

+ (NSInteger)monthDayWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* monthdayComponents = [gregorian components:NSCalendarUnitMonth fromDate:aDate];
    return [monthdayComponents month];
}

+ (NSInteger)yearDayWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitYear fromDate:aDate];
    return [weekdayComponents year];
}

+ (NSInteger)dayWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* dayComponents = [gregorian components:NSCalendarUnitDay fromDate:aDate];
    return [dayComponents day];
}

+ (NSInteger)minuteWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* dayComponents = [gregorian components:NSCalendarUnitMinute fromDate:aDate];
    return [dayComponents minute];
}

+ (NSInteger)numOfDaysBetweenDates:(NSDate*)aStartDate endDate:(NSDate*)anEndDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* daysComponents = [gregorian components:NSCalendarUnitDay fromDate:aStartDate toDate:anEndDate options:0];
    return [daysComponents day];
}

+ (NSDate*)addMinutes:(int)aMinuteQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    [componentsToAdd setMinute:aMinuteQty];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)addHours:(int)anHourQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    [componentsToAdd setHour:anHourQty];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)addDays:(int)aDayQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];    
    [componentsToAdd setDay:aDayQty];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)addMonths:(int)aMonthQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];    
    [componentsToAdd setMonth:aMonthQty];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)addYears:(int)aYearQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    [componentsToAdd setYear:aYearQty];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

+ (NSDate*)configDateWithMinute:(int)aMinuteQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* dateComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour fromDate:aDate];
    [dateComponents setMinute:aMinuteQty];
    [dateComponents setSecond:0];
    [dateComponents setNanosecond:0];
    return [gregorian dateFromComponents:dateComponents];
}

+ (BOOL)convertStringToBool:(NSString*)aField {
    if ([[self trim:aField].lowercaseString isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

+ (NSString*)contactFullName:(NSDictionary*)aContactDict {
    NSString* forename = [aContactDict objectForKey:@"Forename"];
    NSString* surname = [aContactDict objectForKey:@"Surname"];
    if (forename == nil) {
        forename = @"";
    }
    if (surname == nil) {
        surname = @"";
    }
    NSString* fullName = [NSString stringWithFormat:@"%@ %@",[NSString stringWithString:forename],[NSString stringWithString:surname]];
    if ([forename isEqualToString:@""] && [surname isEqualToString:@""]) {
        fullName = @"Noname Staff";
    }
    return fullName;
}

+ (NSString*)addRightSpace:(NSString*)aString {
    return [NSString stringWithFormat:@"%@ ", aString];
}
+ (NSString*)addLeftSpace:(NSString*)aString {
    return [NSString stringWithFormat:@" %@", aString];
}
+ (NSDate*)convertDatetimeStringToDate:(NSString*)aDatetimeString {
    if([aDatetimeString rangeOfString:@"T"].length != 1) {
		aDatetimeString = [NSString stringWithFormat:@"%@T00:00:00.000", aDatetimeString];
	}
	if([aDatetimeString rangeOfString:@"."].length != 1) {
		aDatetimeString = [NSString stringWithFormat:@"%@.000", aDatetimeString];
	}
	if(aDatetimeString == nil || [aDatetimeString isEqualToString:@""]) { return nil; }
	NSDate* outputDate = [[self datetimeFormatter] dateFromString: aDatetimeString];
	return outputDate;
}

+ (NSDateFormatter*)datetimeFormatter {
    static NSDateFormatter* tmpFormatter;
	if(tmpFormatter == nil) {
		tmpFormatter = [[NSDateFormatter alloc] init];
		NSLocale* enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		[tmpFormatter setLocale: enUS];
		[enUS release];
		[tmpFormatter setLenient: YES];
		[tmpFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
	}
	return tmpFormatter;
}

+ (NSComparisonResult)compareDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate {
    NSString* dateFormat = @"yyyyMMdd";
    NSString* tmpStartDateString = [self stringFromDate:aStartDate format:dateFormat];
    NSString* tmpEndDateString = [self stringFromDate:anEndDate format:dateFormat];
    NSNumber* tmpStartDateNumber = [self convertStringToNumber:tmpStartDateString];
    NSNumber* tmpEndDateNumber = [self convertStringToNumber:tmpEndDateString];
    int tmpStartDateInteger = [tmpStartDateNumber intValue];
    int tmpEndDateInteger = [tmpEndDateNumber intValue];
    if (tmpStartDateInteger < tmpEndDateInteger) {
        return NSOrderedAscending;
    } else if (tmpStartDateInteger == tmpEndDateInteger) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

+ (NSIndexPath*)indexPathWithRecognizer:(UITapGestureRecognizer*)aTapRecognizer tableview:(UITableView*)aTableView {
    CGPoint swipeLocation = [aTapRecognizer locationInView:aTableView];
    NSIndexPath* indexPath = [aTableView indexPathForRowAtPoint:swipeLocation];
//    NSLog(@"section row: %d %d", indexPath.section, indexPath.row);
    return indexPath;
}

+ (void)configEdgesForExtendedLayout:(UIViewController*)aUIViewController {
    if ([aUIViewController respondsToSelector:@selector(edgesForExtendedLayout)]) {
        aUIViewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

+ (NSMutableArray*)addOneFieldToObjectsArray:(NSMutableArray*)anObjectsArray fromFieldName:(NSString*)fromFieldName toFieldName:(NSString*)toFieldName {
    NSMutableArray* newObjectsArray = [NSMutableArray arrayWithCapacity:[anObjectsArray count]];
    
    for (NSDictionary* aDict in anObjectsArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        if ([aDict objectForKey:fromFieldName]==nil) {
            [newDict setObject:@"Not Defined" forKey:toFieldName];
        }else{
            [newDict setObject:[aDict objectForKey:fromFieldName] forKey:toFieldName];
        }
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}

+ (void)groupStyleTableView:(UITableView*)tableView tableCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        
        if (addLine == YES) {
            CALayer* lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
            [lineLayer release];
        }
        UIView* testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        [layer release];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
        [testView release];
    }
}

+ (void)handleSeparatorTableView:(UITableView*)tableView {
    CGRect viewRect = CGRectMake(0, 0, 0, 0);
    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
    if ([myView respondsToSelector:@selector(tintColor)]) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [myView release];
}

+ (NSString*)convertStandardToEuropeanDateFormat:(NSString*)aDate {
    NSString* dateString = @"";
    @try {
        NSArray* dateArray = [aDate componentsSeparatedByString:@"-"];
        dateString = [NSString stringWithFormat:@"%@/%@/%@",[dateArray objectAtIndex:2], [dateArray objectAtIndex:1], [dateArray objectAtIndex:0]];
    }
    @catch (NSException *exception) {
        
    }
    return dateString;
}

+ (CGRect)getCorrelativeRootViewRect:(UIViewController*)aRootViewController {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    float width = 0.0f;
    float height = 0.0f;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        width = aRootViewController.view.frame.size.width > aRootViewController.view.frame.size.height ? aRootViewController.view.frame.size.width : aRootViewController.view.frame.size.height;
        height = aRootViewController.view.frame.size.width < aRootViewController.view.frame.size.height ? aRootViewController.view.frame.size.width : aRootViewController.view.frame.size.height;
        return CGRectMake(aRootViewController.view.frame.origin.x, aRootViewController.view.frame.origin.y, width, height);
    } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        width = aRootViewController.view.frame.size.width < aRootViewController.view.frame.size.height ? aRootViewController.view.frame.size.width : aRootViewController.view.frame.size.height;
        height = aRootViewController.view.frame.size.width > aRootViewController.view.frame.size.height ? aRootViewController.view.frame.size.width : aRootViewController.view.frame.size.height;
        return CGRectMake(aRootViewController.view.frame.origin.x, aRootViewController.view.frame.origin.y, width, height);
    }
    return aRootViewController.view.frame;
}
+ (BOOL)systemVersionGreaterThanSeven {
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1;
    
}
+ (int)systemMajorVersion {    
    return [ArcosUtils convertNSIntegerToInt:[[NSProcessInfo processInfo] operatingSystemVersion].majorVersion];
}
+(void)processRotationEvent:(UIView*)aView tabBarHeight:(float)aHeight{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    float diff = 64.0 + aHeight;
    float mainMasterWidth = [GlobalSharedClass shared].mainMasterWidth;
    if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
        aView.frame = CGRectMake(0, 0, 1024-mainMasterWidth, 768 - diff);
    }else{
        aView.frame = CGRectMake(0, 0, 768-mainMasterWidth, 1024 - diff);
    }
}
+(void)processRotationEvent:(UIView*)aView tabBarHeight:(float)aHeight navigationController:(UINavigationController*)aNavigationController {
    UIViewController* myArcosRootViewController = [self getRootView];
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    float diff = [UIApplication sharedApplication].statusBarFrame.size.height + aNavigationController.navigationBar.frame.size.height + aHeight;
    float mainMasterWidth = [GlobalSharedClass shared].mainMasterWidth;
//    if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
//        aView.frame = CGRectMake(0, 0, 1024-mainMasterWidth, 768 - diff);
//    }else{
//        aView.frame = CGRectMake(0, 0, 768-mainMasterWidth, 1024 - diff);
//    }
    aView.frame = CGRectMake(0, 0, myArcosRootViewController.view.bounds.size.width-mainMasterWidth, myArcosRootViewController.view.bounds.size.height - diff);
}
+(CGRect)fromRect4ActionSheet:(UIView*)aView {
    return CGRectMake(aView.center.x, aView.center.y, 1.0, 1.0);
}
+(UIImage*)genericImageWithIUR:(NSNumber*)imageIUR {
    UIImage* anImage = nil;
    if ([imageIUR intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIUR];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    return anImage;
}
+(NSString*)wrapStringByCDATA:(NSString*)aString {
    return [NSString stringWithFormat:@"<![CDATA[%@]]>",aString];
}

+ (UIAlertController*)createDialogBox:(NSString*)message title:(NSString*)title handler:(void (^)(UIAlertAction* action))handler {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:defaultAction];
    return alertController;
}

+ (NSDate*)convertNilDateToDate:(NSDate*)aDate {
    return (aDate == nil) ? [NSDate date] : aDate;
}

+ (NSMutableDictionary*)addTitleToDict:(NSDictionary*)aDict cellKey:(NSString*)aCellKey titleKey:(NSString*)aTitleKey {
    NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithDictionary:[aDict objectForKey:aCellKey]];
    [tmpDict setObject:[self convertNilToEmpty:[aDict objectForKey:aTitleKey]] forKey:@"Title"];
    return tmpDict;
}

+ (NSString*)removeSubstringFromString:(NSString*)aString substring:(NSString*)aSubstring {
    return [aString stringByReplacingOccurrencesOfString:aSubstring withString:@""];
}

+ (float)roundFloatTwoDecimal:(float)aFloat {
    return roundf(aFloat * 100) / 100;    
}

+ (UIImage*)screenshotFromView:(UIView*)aView {
    CGSize size = CGSizeMake(aView.frame.size.width, aView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen.scale);
    CGRect rec = CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height);
    [aView drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)configDetailsColorWithLabel:(UILabel*)aLabel active:(NSNumber*)anActive stockAvailable:(NSNumber*)aStockAvailable bonusBy:(NSNumber*)aBonusBy {
    if (![anActive boolValue]) {
        aLabel.textColor = [UIColor colorWithRed:13.0/255.0 green:152.0/255.0 blue:186.0/255.0 alpha:0.5];
    } else if (aStockAvailable != nil && [aStockAvailable intValue] == 0) {
        aLabel.textColor = [UIColor lightGrayColor];
    } else if ([aBonusBy intValue] != 78) {
        switch ([aBonusBy intValue]) {
            case 82: {//Red
                aLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            }
                break;
            case 71: {//Green
                aLabel.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
            }
                break;
            case 66: {//Blue
                aLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            }
                break;
            case 79: {//Orange
                aLabel.textColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
            }
                break;
            case 80: {//Pink
                aLabel.textColor = [UIColor colorWithRed:1.0 green:192.0/255.0 blue:203.0/255.0 alpha:1.0];
            }
                break;
            default: {
                aLabel.textColor = [UIColor blackColor];
            }
                break;
        }
    } else {
        aLabel.textColor = [UIColor blackColor];
    }
}

+ (NSString*)retrieveDefinedIssuesText {
    NSString* definedIssuesText = @"";
    NSMutableArray* taskObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"TASK"];
    if ([taskObjectList count] > 0) {
        NSDictionary* taskObjectDict = [taskObjectList objectAtIndex:0];
        NSString* taskDetail = [taskObjectDict objectForKey:@"Detail"];
        definedIssuesText = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:taskDetail]];
    }
    
    return definedIssuesText;
}

+ (NSString*)getMimeTypeWithFileName:(NSString*)aFileName {
    NSString* mimeTypeString = @"application/octet-stream";
    @try {
        NSArray* fileComponents = [aFileName componentsSeparatedByString:@"."];
        // Use the filename (index 0) and the extension (index 1) to get path
        NSString* fileExtension = [[fileComponents objectAtIndex:1] lowercaseString];
        if ([@"png" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/png";
        } else if ([@"jpg" isEqualToString:fileExtension] || [@"jpeg" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/jpeg";
        } else if ([@"pdf" isEqualToString:fileExtension]) {
            mimeTypeString = @"application/pdf";
        } else if ([@"mov" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/quicktime";
        } else if ([@"mp4" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/mp4";
        } else if ([@"ibooks" isEqualToString:fileExtension]) {
            mimeTypeString = @"application/x-ibooks+zip";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    return mimeTypeString;
}

+ (void)maskTemplateViewWithView:(UIView*)aView {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
    [maskLayer release];
}


@end
