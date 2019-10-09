//
//  ArcosValidator.h
//  Arcos
//
//  Created by David Kilmartin on 22/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosValidator : NSObject

+(BOOL)isInteger:(NSString*)aField;
+(BOOL)isDecimalWithTwoPlaces:(NSString*)aField;
+(BOOL)isInputDecimalWithTwoPlaces:(NSString*)aField;
+(BOOL)isDecimalWithUnlimitedPlaces:(NSString*)aField;
+(BOOL)checkAllowedFieldValue:(NSString*)aFieldValue;
+(BOOL)checkAllowedFieldValueAndAssigned:(NSString*)aFieldValue;
+(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text target:(UIViewController*)aTarget;
+(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text target:(UIViewController*)aTarget maxLength:(int)aMaxLength;
+(BOOL)isSevenDigitNumberBeginWithFive:(NSString*)aField;
+(BOOL)isEmail:(NSString*)aField;

@end
