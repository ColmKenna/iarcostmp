//
//  NextCheckoutFollowUpTextViewTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutFollowUpTextViewTableViewCell.h"

@implementation NextCheckoutFollowUpTextViewTableViewCell
@synthesize fieldValueTextView = _fieldValueTextView;

- (void)dealloc {
    self.fieldValueTextView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    @try {
        NSMutableArray* dataList = [aCellData objectForKey:@"FieldData"];
        int myIndex = [[aCellData objectForKey:@"Index"] intValue];
        self.fieldValueTextView.text = [dataList objectAtIndex:myIndex];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    NSMutableDictionary* myOrderHeader = [self.baseDelegate retrieveOrderHeaderData];
//    [myOrderHeader setObject:textView.text forKey:[self.cellData objectForKey:@"CellKey"]];
    [self.baseDelegate inputFinishedWithData:textView.text forIndexPath:self.indexPath index:[self.cellData objectForKey:@"Index"]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger originalLength = [text length];
    text = [text stringByReplacingOccurrencesOfString:@"|" withString:@""];
    NSUInteger nextLength = [text length];
    if (originalLength != nextLength) {
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
            [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Maximum text length of %d characters has been exceeded, data has been truncated", [GlobalSharedClass shared].memoDetailMaxLength] title:@"" delegate:nil target:[self.baseDelegate retrieveMainViewController] tag:0 handler:^(UIAlertAction *action) {
                
            }];
        } else {
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:text];
        }
        return NO;
    }
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.baseDelegate retrieveMainViewController]];
}

@end
