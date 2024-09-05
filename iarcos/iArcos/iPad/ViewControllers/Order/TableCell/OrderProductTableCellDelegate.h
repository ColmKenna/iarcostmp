//
//  OrderProductTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 02/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderProductTableCellDelegate <NSObject>

- (void)displayBigProductImageWithProductCode:(NSString*)aProductCode;
- (void)displayProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath*)anIndexPath;
@optional
- (void)toggleShelfImageWithData:(NSMutableDictionary*)aCellData;
- (void)configCurrentTextFieldIndex:(int)anIndex;
- (void)configCurrentIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithData:(NSMutableDictionary*)aData forIndexPath:(NSIndexPath*)anIndexPath;
- (NSNumber*)retrieveCurrentTextFieldValueWithTag:(int)aTag forIndexPath:(NSIndexPath*)anIndexPath;
- (int)retrieveCurrentTextFieldIndex;
- (void)configCurrentTextFieldHighlightedFlag:(BOOL)aFlag;
- (BOOL)retrieveCurrentTextFieldHighlightedFlag;
- (NSIndexPath*)retrieveCurrentIndexPath;
- (int)retrieveViewHasBeenAppearedTime;
- (int)retrieveFirstProductRowIndex;
- (BOOL)retrieveFirstProductRowHasBeenShowedFlag;
- (void)configFirstProductRowHasBeenShowedFlag:(BOOL)aFlag;
- (void)showFooterMatDataWithIndexPath:(NSIndexPath*)anIndexPath;

@end
