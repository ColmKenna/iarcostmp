//
//  FormRowsTableDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 19/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface FormRowsTableDataManager : NSObject {
    NSDictionary* _currentFormDetailDict;
    BOOL _prevStandardOrderPadFlag;
    NSNumber* _prevNumber;
    NSIndexPath* _currentIndexPath;
    BOOL _prevNormalStandardOrderPadFlag;
    NSNumber* _prevNormalNumber;
    BOOL _enablePhysKeyboardFlag;
    int _currentTextFieldIndex;
    BOOL _currentTextFieldHighlightedFlag;
    NSMutableDictionary* _textFieldTagKeyDict;
    int _viewHasBeenAppearedTime;
    int _firstProductRowIndex;
    BOOL _firstProductRowHasBeenShowedFlag;
    BOOL _searchBarFocusedByShortCutFlag;
    BOOL _showFooterMatViewFlag;
}

@property(nonatomic, retain) NSDictionary* currentFormDetailDict;
@property(nonatomic, assign) BOOL prevStandardOrderPadFlag;
@property(nonatomic, retain) NSNumber* prevNumber;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, assign) BOOL prevNormalStandardOrderPadFlag;
@property(nonatomic, retain) NSNumber* prevNormalNumber;
@property(nonatomic, assign) BOOL enablePhysKeyboardFlag;
@property(nonatomic, assign) int currentTextFieldIndex;
@property(nonatomic, assign) BOOL currentTextFieldHighlightedFlag;
@property(nonatomic, retain) NSMutableDictionary* textFieldTagKeyDict;
@property(nonatomic, assign) int viewHasBeenAppearedTime;
@property(nonatomic, assign) int firstProductRowIndex;
@property(nonatomic, assign) BOOL firstProductRowHasBeenShowedFlag;
@property(nonatomic, assign) BOOL searchBarFocusedByShortCutFlag;
@property(nonatomic, assign) BOOL showFooterMatViewFlag;

- (NSMutableArray*)retrieveTableViewDataSourceWithSearchText:(NSString*)aSearchText orderFormDetails:(NSString*)anOrderFormDetails;
- (NSMutableArray*)retrievePredicativeTableViewDataSourceWithOrderFormDetails:(NSString*)anOrderFormDetails;


@end
