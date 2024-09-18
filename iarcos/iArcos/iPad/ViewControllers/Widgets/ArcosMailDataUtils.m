//
//  ArcosMailDataUtils.m
//  iArcos
//
//  Created by David Kilmartin on 08/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailDataUtils.h"
#import "ArcosUtils.h"

@implementation ArcosMailDataUtils



- (NSMutableDictionary*)calculateHeightWithText:(NSString *)aText {
    float bodyTextViewWidth = 668.0;
    float originalTextHeight = 81.15;
    float originalTableCellHeight = 172;
    float originalTextViewHeight = 100;
    float deltaHeight = originalTableCellHeight - originalTextViewHeight;
    
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableAttributedString* attributedTextString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:aText] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    CGRect rect = [attributedTextString boundingRectWithSize:CGSizeMake(bodyTextViewWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];    
    
    [attributedTextString release];
    
    float nextHeight = (rect.size.height > originalTextHeight) ? rect.size.height : originalTextHeight;
    float diffHeight = nextHeight - originalTextHeight;
    float nextTextViewHeight = originalTextViewHeight + diffHeight;
    float nextTableCellHeight = ((nextTextViewHeight + deltaHeight) > originalTableCellHeight) ? (nextTextViewHeight + deltaHeight) : originalTableCellHeight;
    [resultDict setObject:[NSNumber numberWithFloat:nextTextViewHeight] forKey:@"TextViewHeight"];
    [resultDict setObject:[NSNumber numberWithFloat:nextTableCellHeight] forKey:@"CellHeight"];
    
    return resultDict;
}

- (NSMutableDictionary*)calculateHeightWithWebViewHeight:(float)aHeight {
    float originalTableCellHeight = 472;//172
    float originalWebViewHeight = 400; //100
    float deltaHeight = originalTableCellHeight - originalWebViewHeight;
    float nextHeight = (aHeight > originalWebViewHeight) ? aHeight : originalWebViewHeight;
    float diffHeight = nextHeight - originalWebViewHeight;
    float nextWebViewHeight = originalWebViewHeight + diffHeight;
    float nextTableCellHeight = ((nextWebViewHeight + deltaHeight) > originalTableCellHeight) ? (nextWebViewHeight + deltaHeight) : originalTableCellHeight;
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [resultDict setObject:[NSNumber numberWithFloat:nextWebViewHeight] forKey:@"WebViewHeight"];
    [resultDict setObject:[NSNumber numberWithFloat:nextTableCellHeight] forKey:@"CellHeight"];        
    return resultDict;
} 

@end
