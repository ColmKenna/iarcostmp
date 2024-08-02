//
//  FormRowsKeyboardTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 03/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FormRowsKeyboardTableViewCellDelegate <NSObject>

- (void)configGlobalCurrentTextFieldIndex:(int)anIndex;
- (void)configGlobalCurrentIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath*)anIndexPath;
- (NSNumber*)retrieveCurrentTextFieldValueWithIndex:(int)anIndex forIndexPath:(NSIndexPath*)anIndexPath;
- (int)retrieveGlobalCurrentTextFieldIndex;
- (void)configGlobalCurrentTextFieldHighlightedFlag:(BOOL)aFlag;
- (BOOL)retrieveGlobalCurrentTextFieldHighlightedFlag;
- (NSIndexPath*)retrieveGlobalCurrentIndexPath;

@end

