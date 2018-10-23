//
//  DashboardMainTemplateTextButton.m
//  iArcos
//
//  Created by David Kilmartin on 13/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateTextButton.h"

@implementation DashboardMainTemplateTextButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configButtonWithData:(DashboardMainTemplateDataObject*)aDataObject {
    self.contentHorizontalAlignment = aDataObject.horizontalAlignment;
    self.contentVerticalAlignment = aDataObject.verticalAlignment;
    [self setTitle:aDataObject.text forState:UIControlStateNormal];
}


@end
