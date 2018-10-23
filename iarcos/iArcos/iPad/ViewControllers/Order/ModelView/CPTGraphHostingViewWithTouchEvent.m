//
//  CPTGraphHostingViewWithTouchEvent.m
//  Arcos
//
//  Created by David Kilmartin on 03/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CPTGraphHostingViewWithTouchEvent.h"

@implementation CPTGraphHostingViewWithTouchEvent
@synthesize pieRotation = _pieRotation;
@synthesize rotatePieChart = _rotatePieChart;
@synthesize isInMiniMode = _isInMiniMode;
@synthesize isPieChart = _isPieChart;
@synthesize isLocked = _isLocked;


- (void) dealloc {
    if (self.pieRotation != nil) {
        self.pieRotation = nil;
    }
    if (self.rotatePieChart != nil) {
        self.rotatePieChart = nil;
    }
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.isInMiniMode) return;    
    pieChartCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    touchBeginPosition = [[[event touchesForView:self] anyObject] locationInView:self];
    
//    NSLog(@"self.frame.size is %f, %f", self.frame.size.width/2, self.frame.size.height/2); 
    CPTGraph* graph = self.hostedGraph;
//    NSLog(@"[[graph allPlots] count] %d", [[graph allPlots] count]);
    if ([[graph allPlots] count] != 1) {
        self.isPieChart = NO;
        return;
    }
    
    if ([[graph plotAtIndex:0] isKindOfClass:[CPTPieChart class]]) {
        self.isPieChart = YES;
//        NSLog(@"is CPTPieChart");
    } else {
        self.isPieChart = NO;
//        NSLog(@"is not CPTPieChart");
    }
    self.rotatePieChart = (CPTPieChart*)[graph plotAtIndex:0];

    /**
    NSLog(@"touchesBegan customize WithTouchEvent.");
    NSLog(@"self.hostedGraph class is %@", NSStringFromClass([self.hostedGraph class]));
    NSLog(@"self.rotatePieChart.center is %f, %f ", self.rotatePieChart.contentsCenter.origin.x, self.rotatePieChart.contentsCenter.origin.y);
    NSLog(@"self.center is %f, %f ", self.center.x, self.center.y);
     */
//    CGPoint centerPoint = [self.hostedGraph convertPoint:self.center fromLayer:self.layer];
//    NSLog(@"self.centerPoint is %f, %f ", self.center.x, self.center.y);
    /**
    CGPoint pointOfTouch = [[[event touchesForView:self] anyObject] locationInView:self];
    CGPoint convertedPointOfTouch = [self.hostedGraph convertPoint:pointOfTouch toLayer:self.layer];
    
    NSLog(@"self.pointOfTouch is %f, %f ", pointOfTouch.x, pointOfTouch.y);
    NSLog(@"self.convertedPointOfTouch is %f, %f ", convertedPointOfTouch.x, convertedPointOfTouch.y);
     */
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (!self.isPieChart || self.isInMiniMode) return;    
//    NSLog(@"touchesMoved customize WithTouchEvent.");
//    CGPoint touchMovePosition = [[[event touchesForView:self] anyObject] locationInView:self];
//    touchMovePosition.x 
//    NSLog(@"touchMovePosition is: %f, %f", touchMovePosition.x, touchMovePosition.y);
/**    
    CPTGraph* graph = self.hostedGraph;
    NSLog(@"[[graph allPlots] count] %d", [[graph allPlots] count]);
    if ([[graph allPlots] count] != 1) return;
    
    if ([[graph plotAtIndex:0] isKindOfClass:[CPTPieChart class]]) {
        NSLog(@"is CPTPieChart");
    } else {
        NSLog(@"is not CPTPieChart");
    }
    self.rotatePieChart = (CPTPieChart*)[graph plotAtIndex:0];
    
    // Add a rotation animation
    self.pieRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];    
    self.pieRotation.removedOnCompletion = YES;
    self.pieRotation.fromValue = [NSNumber numberWithFloat:self.rotatePieChart.startAngle];
    self.pieRotation.toValue = [NSNumber numberWithFloat:0.0f];
    self.pieRotation.duration = 3.0f;
    self.pieRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.pieRotation.delegate = self;

    [self.rotatePieChart addAnimation:self.pieRotation forKey:@"rotation"];
*/ 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {    
    [super touchesEnded:touches withEvent:event];
    if (!self.isPieChart || self.isInMiniMode) return;
//    NSLog(@"touchesEnded customize WithTouchEvent.");
    touchEndPosition = [[[event touchesForView:self] anyObject] locationInView:self];
    
    
    float radian = [self calculateAngleBetweenTwoPoints];
    
    CPTGraph* graph = self.hostedGraph;
    if ([[graph allPlots] count] != 1) return;        
    if ([[graph plotAtIndex:0] isKindOfClass:[CPTPieChart class]]) {
//        NSLog(@"is CPTPieChart");
    } else {
//        NSLog(@"is not CPTPieChart");
    }
//    [self.rotatePieChart removeAnimationForKey:@"rotation"];

    /**
    if ((touchEndPosition.x < touchBeginPosition.x && touchEndPosition.y < touchBeginPosition.y) || (touchEndPosition.x < touchBeginPosition.x && touchEndPosition.y > touchBeginPosition.y) || (touchEndPosition.x > touchBeginPosition.x && touchEndPosition.y > touchBeginPosition.y) || (touchEndPosition.x > touchBeginPosition.x && touchEndPosition.y < touchBeginPosition.y)) {
        radian = - radian;
    }
     */
    if ((touchEndPosition.x < touchBeginPosition.x && touchEndPosition.y < touchBeginPosition.y) || (touchEndPosition.x > touchBeginPosition.x && touchEndPosition.y < touchBeginPosition.y)) {
        radian = - radian;
    }
    
    self.rotatePieChart.startAngle = self.rotatePieChart.startAngle - radian;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
//    NSLog(@"touchesEnded customize WithTouchEvent.");
}

- (float)calculateAngleBetweenTwoPoints {
    float distinceAB = sqrtf(powf(touchEndPosition.x - touchBeginPosition.x, 2) + powf(touchEndPosition.y - touchBeginPosition.y, 2));
    float distinceCA = sqrtf(powf(touchBeginPosition.x - pieChartCenter.x, 2) + powf(touchBeginPosition.y - pieChartCenter.y, 2));
    float distinceCB = sqrtf(powf(touchEndPosition.x - pieChartCenter.x, 2) + powf(touchEndPosition.y - pieChartCenter.y, 2));
//    NSLog(@"calculateAngleBetweenTwoPoints AB: %f, CA: %f, CB: %f", distinceAB, distinceCA, distinceCB);
//    acosf((powf(distinceCA, 2) + powf(distinceCB, 2) - powf(distinceAB, 2)) / 2 * distinceCA * distinceCB);
//    NSLog(@"0.5 angle is %f", sinf(M_PI_2));
//    NSLog(@"value is %f", (powf(distinceCA, 2) + powf(distinceCB, 2) - powf(distinceAB, 2)) / (2 * distinceCA * distinceCB));
    float radian = acosf((powf(distinceCA, 2) + powf(distinceCB, 2) - powf(distinceAB, 2)) / (2 * distinceCA * distinceCB));
//    NSLog(@"triangle radius is %f", radian);
//    NSLog(@"triangle angle is %f", radian * 180 / M_PI);
    return radian;
}


@end
