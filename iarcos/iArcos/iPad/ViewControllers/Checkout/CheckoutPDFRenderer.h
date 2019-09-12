//
//  CheckoutPDFRenderer.h
//  iArcos
//
//  Created by David Kilmartin on 08/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "ArcosUtils.h"

@interface CheckoutPDFRenderer : NSObject {
    int _pageWidth;
    int _pageHeight;
    int _rowVerticalSpace;
    NSMutableDictionary* _viewHashMap;
}

@property(nonatomic, assign) int pageWidth;
@property(nonatomic, assign) int pageHeight;
@property(nonatomic, assign) int rowVerticalSpace;
@property(nonatomic, retain) NSMutableDictionary* viewHashMap;

- (void)drawImage:(UIImage*)anImage inRect:(CGRect)aRect;
- (void)drawText:(NSString*)aText inRect:(CGRect)aRect;
- (void)drawText:(NSString*)aText inRect:(CGRect)aRect alignment:(NSTextAlignment)aTextAlignment;
- (void)drawText:(NSString*)aText inRect:(CGRect)aRect alignment:(NSTextAlignment)aTextAlignment font:(UIFont*)aFont;
- (void)drawText:(NSString*)aText inRect:(CGRect)aRect alignment:(NSTextAlignment)aTextAlignment font:(UIFont*)aFont textColor:(UIColor*)aColor;
- (void)drawLineFromPoint:(CGPoint)aFromPoint toPoint:(CGPoint)aToPoint;
- (CGRect)retrieveViewRectWithTag:(int)aTag;
- (CGRect)retrieveNewViewRect:(CGRect)aRect index:(int)anIndex verticalSpace:(int)aSpace pageNum:(int)aPageNum;


@end
