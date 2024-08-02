//
//  FormRowsKeyboardDataManager.m
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsKeyboardDataManager.h"

@implementation FormRowsKeyboardDataManager
@synthesize displayList = _displayList;
@synthesize globalCurrentTextFieldIndex = _globalCurrentTextFieldIndex;
@synthesize globalCurrentIndexPath = _globalCurrentIndexPath;
@synthesize textFieldKeyList = _textFieldKeyList;
@synthesize globalCurrentTextFieldHighlightedFlag = _globalCurrentTextFieldHighlightedFlag;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.globalCurrentTextFieldIndex = 0;
        self.textFieldKeyList = [NSMutableArray arrayWithObjects:@"Qty", @"Bonus", @"Discount", nil];
        self.globalCurrentTextFieldHighlightedFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.globalCurrentIndexPath = nil;
    self.textFieldKeyList = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:90];
    for (int i = 0; i < 90; i++) {
        NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [tmpDataDict setObject:[NSString stringWithFormat:@"product%d",i] forKey:@"Details"];
        [tmpDataDict setObject:[NSNumber numberWithInt:0] forKey:@"Qty"];
        [tmpDataDict setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
        [tmpDataDict setObject:[NSNumber numberWithInt:0] forKey:@"Discount"];
        [self.displayList addObject:tmpDataDict];
    }
    
}

- (void)processInputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    NSString* textFieldKey = [self.textFieldKeyList objectAtIndex:self.globalCurrentTextFieldIndex];
    [tmpDataDict setObject:[ArcosUtils convertStringToNumber:aData] forKey:textFieldKey];
}

- (NSNumber*)processRetrieveCurrentTextFieldValueWithIndex:(int)anIndex forIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    NSString* textFieldKey = [self.textFieldKeyList objectAtIndex:anIndex];
    return [tmpDataDict objectForKey:textFieldKey];
}

- (int)processRetrieveGlobalCurrentTextFieldIndex {
    return self.globalCurrentTextFieldIndex;
}

@end
