//
//  DashboardMainTemplateDataObject.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateDataObject.h"

@implementation DashboardMainTemplateDataObject
@synthesize IUR = _IUR;
@synthesize text = _text;
@synthesize xPos = _xPos;
@synthesize yPos = _yPos;
@synthesize width = _width;
@synthesize height = _height;
@synthesize buttonType = _buttonType;
@synthesize horizontalAlignment = _horizontalAlignment;
@synthesize verticalAlignment = _verticalAlignment;
@synthesize imageIUR = _imageIUR;
@synthesize imageWidth = _imageWidth;
@synthesize imageHeight = _imageHeight;
@synthesize bgColor = _bgColor;
@synthesize fgColor = _fgColor;

- (instancetype)createInstance:(float)aXPos yPos:(float)aYPos width:(float)aWidth height:(float)aHeight {
    self = [super init];
    if (self != nil) {
        self.xPos = aXPos;
        self.yPos = aYPos;
        self.width = aWidth;
        self.height = aHeight;
    }
    return self;
}

- (void)dealloc {
    self.text = nil;
    self.bgColor = nil;
    self.fgColor = nil;
    
    [super dealloc];
}

@end
