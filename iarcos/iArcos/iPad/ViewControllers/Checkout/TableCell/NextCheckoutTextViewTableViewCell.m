//
//  NextCheckoutTextViewTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutTextViewTableViewCell.h"

@implementation NextCheckoutTextViewTableViewCell
@synthesize fieldValueTextView = _fieldValueTextView;

- (void)dealloc {
    self.fieldValueTextView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueTextView.text = [aCellData objectForKey:@"FieldData"];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary* myOrderHeader = [self.baseDelegate retrieveOrderHeaderData];
    [myOrderHeader setObject:textView.text forKey:[self.cellData objectForKey:@"CellKey"]];    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.baseDelegate retrieveMainViewController]];
}

@end
