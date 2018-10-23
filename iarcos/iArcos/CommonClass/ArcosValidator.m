//
//  ArcosValidator.m
//  Arcos
//
//  Created by David Kilmartin on 22/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosValidator.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"


@implementation ArcosValidator

+(BOOL)isInteger:(NSString*)aField {
    NSString* expression = @"^(0|[1-9][0-9]*)$";    
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    
    if (match){
        return YES;
    }
    return NO;
}

+(BOOL)isDecimalWithTwoPlaces:(NSString*)aField {
    NSString* expression = @"^(0|[1-9][0-9]*)(\\.[0-9]{1,2})?$";    
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    
    if (match){
        return YES;
    }
    return NO;
}

+(BOOL)isInputDecimalWithTwoPlaces:(NSString*)aField {
    NSString* expression = @"^(0|[1-9][0-9]*)(\\.[0-9]{0,2})?$";
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    
    if (match){
        return YES;
    }
    return NO;
}

+(BOOL)isDecimalWithUnlimitedPlaces:(NSString*)aField {
//    NSString* expression = @"^[0-9]+(\\.[0-9]+)?$";    
    NSString* expression = @"^(0|[1-9][0-9]*)(\\.[0-9]+)?$";    
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    
    if (match){
        return YES;
    }
    return NO;
}

+(BOOL)checkAllowedFieldValue:(NSString*)aFieldValue {
    if (aFieldValue == nil || [aFieldValue isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+(BOOL)checkAllowedFieldValueAndAssigned:(NSString*)aFieldValue {
    if (aFieldValue == nil || [aFieldValue isEqualToString:@""] || [aFieldValue isEqualToString:@"UnAssigned"]) {
        return NO;
    }
    return YES;
}

+(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text target:(UIViewController*)aTarget {
    NSUInteger oldLength = [textView.text length];
    NSUInteger replacementLength = [text length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL memoResultFlag = (newLength <= [GlobalSharedClass shared].memoDetailMaxLength);
    if (!memoResultFlag) {
        NSUInteger currentLength = oldLength - rangeLength;
        NSUInteger allowedAddedLength = 0;
        if ([GlobalSharedClass shared].memoDetailMaxLength > currentLength) {
            allowedAddedLength = [GlobalSharedClass shared].memoDetailMaxLength - currentLength;
        }
        textView.text = [textView.text stringByReplacingCharactersInRange:range withString:[text substringToIndex:allowedAddedLength]];
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Maximum text length of %d characters has been exceeded, data has been truncated", [GlobalSharedClass shared].memoDetailMaxLength] title:@"" delegate:nil target:aTarget tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
    return memoResultFlag;
}

+(BOOL)isSevenDigitNumberBeginWithFive:(NSString*)aField {
    NSString* expression = @"^(5)([0-9]{6})$";
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    if (match){
        return YES;
    }
    return NO;
}

+(BOOL)isEmail:(NSString*)aField {
    NSString* expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,7}$";
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:aField options:0 range:NSMakeRange(0, [aField length])];
    
    if (match){
        return YES;
    }
    return NO;
}
@end
