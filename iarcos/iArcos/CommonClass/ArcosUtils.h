//
//  ArcosUtils.h
//  Arcos
//
//  Created by David Kilmartin on 08/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosUtils : NSObject {
    
}

+ (NSString*)convertNilToEmpty:(NSString*)aField;
+ (NSString*)convertDatetimeToDate:(NSString*)aField;
+ (UIActivityIndicatorView*) initActivityIndicatorWithView:(UIView*)aView;
+ (NSString*)convertToFloatString:(NSString*)aField;
+ (NSString*)convertZeroToBlank:(NSString*)aField;
+ (NSString*)convertBlankToZero:(NSString*)aField;
+ (NSString*)convertUnAssignedToBlank:(NSString*)aField;
//+ (void)showMsg:(int)errorCode message:(NSString*)message delegate:(id)delegate;
+ (NSString*)convertToIntString:(NSString*)aField;
+ (NSString*)convertNumberToIntString:(NSNumber*)aNumber;
+ (NSObject*)convertNilDateToNull:(NSDate*)aDate;
//+ (void)showMsg:(NSString*)message delegate:(id)delegate;
//+ (void)showMsg:(NSString*)message title:(NSString*)title delegate:(id)delegate;
//+ (void)showMsg:(NSString*)message title:(NSString*)title delegate:(id)delegate tag:(int)aTag;
+ (NSString*)retrieveTitleWithCode:(int)aCode;
+ (void)showDialogBox:(NSString*)message title:(NSString*)title target:(UIViewController*)aTarget handler:(void (^)(UIAlertAction* action))handler;
+ (void)showDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag handler:(void (^)(UIAlertAction* action))handler;
+ (void)showTwoBtnsDialogBox:(NSString*)message title:(NSString*)title target:(UIViewController*)aTarget lBtnText:(NSString*)lBtnText rBtnText:(NSString*)rBtnText lBtnHandler:(void (^)(UIAlertAction* action))lBtnHandler rBtnHandler:(void (^)(UIAlertAction* action))rBtnHandler;
+ (void)showTwoBtnsDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag lBtnText:(NSString*)lBtnText rBtnText:(NSString*)rBtnText lBtnHandler:(void (^)(UIAlertAction* action))lBtnHandler rBtnHandler:(void (^)(UIAlertAction* action))rBtnHandler;
+ (void)showThreeBtnsDialogBox:(NSString*)message title:(NSString*)title delegate:(id)delegate target:(UIViewController*)aTarget tag:(int)aTag lBtnText:(NSString*)lBtnText rBtnText:(NSString*)rBtnText thirdBtnText:(NSString*)thirdBtnText lBtnHandler:(void (^)(UIAlertAction* action))lBtnHandler rBtnHandler:(void (^)(UIAlertAction* action))rBtnHandler thirdBtnHandler:(void (^)(UIAlertAction* action))thirdBtnHandler;
+ (NSString*)convertToString:(id)data;
+ (bool)checkFieldValue:(id)aFieldValue;
+ (NSNumber*)convertStringToNumber:(NSString*)aField;
+ (NSNumber*)convertStringToFloatNumber:(NSString*)aField;
+ (NSDecimalNumber*)convertStringToDecimalNumber:(NSString*)aField;
+ (NSString*)trim:(NSString*)aField;
+ (NSString*)trimPipe:(NSString*)aField;
+ (NSString*)trim:(NSString*)aField characters:(NSString*)aCharacters;
+ (NSString*)convertIntToString:(int)aField;
+ (NSString*)convertFloatToString:(float)aField;
+ (unsigned int)convertNSUIntegerToUnsignedInt:(NSUInteger)aField;
+ (int)convertNSIntegerToInt:(NSInteger)aField;
+ (NSNumber*)convertNilToZero:(NSNumber*)aField;
+ (NSDate*)todayWithFormat:(NSString*)dateFormat;
+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)dateFormat;
+ (NSString*)convertNoneToEmpty:(NSString*)aField;
+ (bool)checkFieldValueAndUnAssigned:(id)aFieldValue;
+ (CGRect)correctViewFrame:(UIView*)rootView;
+ (NSDate*)sundayOfWeek:(NSDate*)aDate;
//in this case, Sunday means weekend
+ (NSDate*)prevSunday:(NSDate*)aCurrentSundayDate;
+ (NSDate*)nextSunday:(NSDate*)aCurrentSundayDate;
+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat;
+ (NSString*)weekDayNameFromDate:(NSDate*)aDate format:(NSString*)dateFormat;
+ (NSString*)stringFromFileSize:(NSNumber*)aFileSize;
+ (NSString*)convertToString:(id)aFieldValue fieldType:(NSString*)aFieldType;
+ (UIViewController*)getRootView;
+ (NSNumber*)getDayOfWeekend;
+ (NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend;
+ (NSDate*)beginOfWeek:(NSDate*)aCurrentSundayDate;
+ (NSDate*)dateWithBeginOfWeek:(NSDate*)aBeginOfWeekDate interval:(NSInteger)anInterval;
+ (NSDate*)beginDayOfMonth:(NSInteger)aMonthNumber withDate:(NSDate*)aDate;
+ (NSDate*)endDayOfMonth:(NSInteger)aMonthNumber withDate:(NSDate*)aDate;
+ (NSDate*)endDayOfYearWithDate:(NSDate*)aDate;
+ (NSDate*)beginOfDay:(NSDate*)aDate;
+ (NSDate*)beginOfDayWithZeroTime:(NSDate*)aDate;
+ (NSDate*)endOfDay:(NSDate*)aDate;
+ (NSDate*)endOfDayWithMaxTime:(NSDate*)aDate;
+ (NSInteger)weekDayWithDate:(NSDate*)aDate;
+ (NSInteger)monthDayWithDate:(NSDate*)aDate;
+ (NSInteger)yearDayWithDate:(NSDate*)aDate;
+ (NSInteger)dayWithDate:(NSDate*)aDate;
+ (NSInteger)minuteWithDate:(NSDate*)aDate;
+ (NSInteger)numOfDaysBetweenDates:(NSDate*)aStartDate endDate:(NSDate*)anEndDate;
+ (NSDate*)addMinutes:(int)aMinuteQty date:(NSDate*)aDate;
+ (NSDate*)addHours:(int)anHourQty date:(NSDate*)aDate;
+ (NSDate*)addDays:(int)aDayQty date:(NSDate*)aDate;
+ (NSDate*)addMonths:(int)aMonthQty date:(NSDate*)aDate;
+ (NSDate*)addYears:(int)aYearQty date:(NSDate*)aDate;
+ (NSDate*)configDateWithMinute:(int)aMinuteQty date:(NSDate*)aDate;
+ (BOOL)convertStringToBool:(NSString*)aField;
+ (NSString*)contactFullName:(NSDictionary*)aContactDict;
+ (NSString*)addRightSpace:(NSString*)aString;
+ (NSString*)addLeftSpace:(NSString*)aString;
+ (NSDate*)convertDatetimeStringToDate:(NSString*)aDatetimeString;
+ (NSDateFormatter*)datetimeFormatter;
+ (NSComparisonResult)compareDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate;
+ (NSIndexPath*)indexPathWithRecognizer:(UITapGestureRecognizer*)aTapRecognizer tableview:(UITableView*)aTableView;
+ (void)configEdgesForExtendedLayout:(UIViewController*)aUIViewController;
+ (NSMutableArray*)addOneFieldToObjectsArray:(NSMutableArray*)anObjectsArray fromFieldName:(NSString*)fromFieldName toFieldName:(NSString*)toFieldName;
+ (void)groupStyleTableView:(UITableView*)tableView tableCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath;
+ (void)handleSeparatorTableView:(UITableView*)tableView;
+ (NSString*)convertStandardToEuropeanDateFormat:(NSString*)aDate;
+ (CGRect)getCorrelativeRootViewRect:(UIViewController*)aRootViewController;
+ (BOOL)systemVersionGreaterThanSeven;
+ (int)systemMajorVersion;
+(void)processRotationEvent:(UIView*)aView tabBarHeight:(float)aHeight;
+(void)processRotationEvent:(UIView*)aView tabBarHeight:(float)aHeight navigationController:(UINavigationController*)aNavigationController;
+(CGRect)fromRect4ActionSheet:(UIView*)aView;
+(UIImage*)genericImageWithIUR:(NSNumber*)imageIUR;
+(NSString*)wrapStringByCDATA:(NSString*)aString;
+ (UIAlertController*)createDialogBox:(NSString*)message title:(NSString*)title handler:(void (^)(UIAlertAction* action))handler;
+ (NSDate*)convertNilDateToDate:(NSDate*)aDate;
+ (NSMutableDictionary*)addTitleToDict:(NSDictionary*)aDict cellKey:(NSString*)aCellKey titleKey:(NSString*)aTitleKey;
+ (NSString*)removeSubstringFromString:(NSString*)aString substring:(NSString*)aSubstring;
+ (float)roundFloatTwoDecimal:(float)aFloat;
+ (float)roundFloatThreeDecimal:(float)aFloat;
+ (float)roundFloatFourDecimal:(float)aFloat;
+ (UIImage*)screenshotFromView:(UIView*)aView;
+ (void)configDetailsColorWithLabel:(UILabel*)aLabel active:(NSNumber*)anActive stockAvailable:(NSNumber*)aStockAvailable bonusBy:(NSNumber*)aBonusBy;
+ (NSString*)retrieveDefinedIssuesText;
+ (NSString*)getMimeTypeWithFileName:(NSString*)aFileName;
+ (void)maskTemplateViewWithView:(UIView*)aView;

@end
