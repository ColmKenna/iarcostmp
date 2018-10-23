//
//  DashboardMainTemplateDataObject.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardMainTemplateDataObject : NSObject {
    int _IUR;
    NSString* _text;
    float _xPos;
    float _yPos;
    float _width;
    float _height;
    int _buttonType;
    int _horizontalAlignment;
    int _verticalAlignment;
    int _imageIUR;
    float _imageWidth;
    float _imageHeight;
    NSString* _bgColor;
    NSString* _fgColor;
}

@property(nonatomic, assign) int IUR;
@property(nonatomic, retain) NSString* text;
@property(nonatomic, assign) float xPos;
@property(nonatomic, assign) float yPos;
@property(nonatomic, assign) float width;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) int buttonType;
@property(nonatomic, assign) int horizontalAlignment;
@property(nonatomic, assign) int verticalAlignment;
@property(nonatomic, assign) int imageIUR;
@property(nonatomic, assign) float imageWidth;
@property(nonatomic, assign) float imageHeight;
@property(nonatomic, retain) NSString* bgColor;
@property(nonatomic, retain) NSString* fgColor;

- (instancetype)createInstance:(float)aXPos yPos:(float)aYPos width:(float)aWidth height:(float)aHeight;

@end
