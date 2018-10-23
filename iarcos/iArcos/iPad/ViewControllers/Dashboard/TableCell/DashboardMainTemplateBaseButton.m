//
//  DashboardMainTemplateBaseButton.m
//  iArcos
//
//  Created by David Kilmartin on 13/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateBaseButton.h"

@implementation DashboardMainTemplateBaseButton
@synthesize dashboardMainTemplateDataObject = _dashboardMainTemplateDataObject;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configButtonWithData:(DashboardMainTemplateDataObject*)aDataObject {
    
}

- (void)dealloc {
    self.dashboardMainTemplateDataObject = nil;
    
    [super dealloc];
}



@end
