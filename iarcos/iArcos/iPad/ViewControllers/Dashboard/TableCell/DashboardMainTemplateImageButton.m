//
//  DashboardMainTemplateImageButton.m
//  iArcos
//
//  Created by David Kilmartin on 13/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateImageButton.h"
#import "ArcosCoreData.h"

@implementation DashboardMainTemplateImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configButtonWithData:(DashboardMainTemplateDataObject*)aDataObject {
    UIImage* imageData = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:aDataObject.imageIUR]];
    [self setImage:imageData forState:UIControlStateNormal];    
}

@end
