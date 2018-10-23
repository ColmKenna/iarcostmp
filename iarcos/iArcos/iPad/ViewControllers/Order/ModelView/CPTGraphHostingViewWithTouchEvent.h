//
//  CPTGraphHostingViewWithTouchEvent.h
//  Arcos
//
//  Created by David Kilmartin on 03/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface CPTGraphHostingViewWithTouchEvent : CPTGraphHostingView {
    int touchPositionX;
    int touchPositionY;
    CGPoint touchBeginPosition;
    CGPoint touchEndPosition;
    CGPoint pieChartCenter;
    
    CABasicAnimation* _pieRotation;
    CPTPieChart* _rotatePieChart;
    BOOL _isInMiniMode;
    BOOL _isPieChart;
    BOOL _isLocked; 
}

@property (nonatomic, retain) CABasicAnimation* pieRotation;
@property (nonatomic, retain) CPTPieChart* rotatePieChart;
@property (nonatomic, assign) BOOL isInMiniMode;
@property (nonatomic, assign) BOOL isPieChart;
@property (nonatomic, assign) BOOL isLocked;


- (float)calculateAngleBetweenTwoPoints;

@end
