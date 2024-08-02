//
//  FormRowsKeyboardDataManager.h
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"

@interface FormRowsKeyboardDataManager : NSObject {
    NSMutableArray* _displayList;
    int _globalCurrentTextFieldIndex;
    NSIndexPath* _globalCurrentIndexPath;
    NSMutableArray* _textFieldKeyList;
    BOOL _globalCurrentTextFieldHighlightedFlag;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) int globalCurrentTextFieldIndex;
@property(nonatomic, retain) NSIndexPath* globalCurrentIndexPath;
@property(nonatomic, retain) NSMutableArray* textFieldKeyList;
@property(nonatomic, assign) BOOL globalCurrentTextFieldHighlightedFlag;

- (void)createBasicData;
- (void)processInputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath *)anIndexPath;
- (NSNumber*)processRetrieveCurrentTextFieldValueWithIndex:(int)anIndex forIndexPath:(NSIndexPath*)anIndexPath;
- (int)processRetrieveGlobalCurrentTextFieldIndex;

@end

