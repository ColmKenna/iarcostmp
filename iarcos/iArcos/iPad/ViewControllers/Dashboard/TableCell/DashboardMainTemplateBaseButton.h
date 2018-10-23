//
//  DashboardMainTemplateBaseButton.h
//  iArcos
//
//  Created by David Kilmartin on 13/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosBorderUIButton.h"
#import "DashboardMainTemplateDataObject.h"

@interface DashboardMainTemplateBaseButton : ArcosBorderUIButton {
    DashboardMainTemplateDataObject* _dashboardMainTemplateDataObject;
}

@property(nonatomic, retain) DashboardMainTemplateDataObject* dashboardMainTemplateDataObject;

- (void)configButtonWithData:(DashboardMainTemplateDataObject*)aDataObject;

@end
