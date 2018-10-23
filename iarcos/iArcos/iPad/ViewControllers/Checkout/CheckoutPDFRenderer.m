//
//  CheckoutPDFRenderer.m
//  iArcos
//
//  Created by David Kilmartin on 08/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPDFRenderer.h"

@implementation CheckoutPDFRenderer
@synthesize pageWidth = _pageWidth;
@synthesize pageHeight = _pageHeight;
@synthesize rowVerticalSpace = _rowVerticalSpace;
@synthesize viewHashMap = _viewHashMap;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.pageWidth = 595;//612
        self.pageHeight = 840;//810
        self.rowVerticalSpace = 0;
        NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceTemplateViewController" owner:nil options:nil];
        self.viewHashMap = [NSMutableDictionary dictionaryWithCapacity:12];
        
        UIView* mainView = [objects objectAtIndex:0];
        
        for (UIView* view in [mainView subviews]) {
            if (view.tag > 0) {
                [self.viewHashMap setObject:[NSValue valueWithCGRect:view.frame] forKey:[NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:view.tag]]];
            }
        }
    }
    return self;
}

- (void)dealloc {
    self.viewHashMap = nil;
    
    [super dealloc];
}


- (void)drawImage:(UIImage*)anImage inRect:(CGRect)aRect {
    [anImage drawInRect:aRect];
}

- (void)drawText:(NSString*)aText inRect:(CGRect)aRect {
    CFStringRef stringRef = (__bridge CFStringRef)aText;
//     Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, aRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, aRect.origin.y * 2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * aRect.origin.y * 2);
    
    CFRelease(frameRef);
    CFRelease(framesetter);
    CFRelease(currentText);
}

- (void)drawText:(NSString*)aText inRect:(CGRect)aRect alignment:(NSTextAlignment)aTextAlignment {
    //     Prepare the text using a Core Text Framesetter
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
    [paragraphStyle setAlignment:aTextAlignment];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:aText];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [aText length])];
    [paragraphStyle release];
    CFAttributedStringRef currentText = (CFAttributedStringRef)attributedString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, aRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, aRect.origin.y * 2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * aRect.origin.y * 2);
    
    CFRelease(frameRef);
    CFRelease(framesetter);
    [attributedString release];
}

- (void)drawText:(NSString*)aText inRect:(CGRect)aRect alignment:(NSTextAlignment)aTextAlignment font:(UIFont*)aFont{
    //     Prepare the text using a Core Text Framesetter
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
    [paragraphStyle setAlignment:aTextAlignment];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:aText];
    if (aFont != nil) {
        [attributedString addAttribute:NSFontAttributeName value:aFont range:NSMakeRange(0, [aText length])];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [aText length])];
    [paragraphStyle release];
    CFAttributedStringRef currentText = (CFAttributedStringRef)attributedString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, aRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, aRect.origin.y * 2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * aRect.origin.y * 2);
    
    CFRelease(frameRef);
    CFRelease(framesetter);
    [attributedString release];
}

- (void)drawLineFromPoint:(CGPoint)aFromPoint toPoint:(CGPoint)aToPoint {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0f, 0.0f, 0.0f, 1.0f};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, aFromPoint.x, aFromPoint.y);
    CGContextAddLineToPoint(context, aToPoint.x, aToPoint.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (CGRect)retrieveViewRectWithTag:(int)aTag {
    NSValue* auxNSValue = [self.viewHashMap objectForKey:[NSNumber numberWithInt:aTag]];
    return [auxNSValue CGRectValue];
}

- (CGRect)retrieveNewViewRect:(CGRect)aRect index:(int)anIndex verticalSpace:(int)aSpace pageNum:(int)aPageNum {
    return CGRectMake(aRect.origin.x, aRect.origin.y + anIndex * aRect.size.height + anIndex * aSpace - self.pageHeight * aPageNum , aRect.size.width, aRect.size.height);
}



@end
