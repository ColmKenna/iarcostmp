//
//  DashboardMainTemplateDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateDataManager.h"

@implementation DashboardMainTemplateDataManager
@synthesize displayList = _displayList;

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray* row0 = [NSMutableArray arrayWithCapacity:3];
    DashboardMainTemplateDataObject* dashboardMainTemplateDataObject00 =  [[[DashboardMainTemplateDataObject alloc] createInstance:10 yPos:10 width:200 height:90] autorelease];
    dashboardMainTemplateDataObject00.IUR = 10;
    dashboardMainTemplateDataObject00.text = @"a";
    dashboardMainTemplateDataObject00.horizontalAlignment = 0;
    dashboardMainTemplateDataObject00.verticalAlignment = 0;
    dashboardMainTemplateDataObject00.buttonType = 0;    
    [row0 addObject:dashboardMainTemplateDataObject00];
    DashboardMainTemplateDataObject* dashboardMainTemplateDataObject01 = [[[DashboardMainTemplateDataObject alloc] createInstance:320 yPos:10 width:320 height:90] autorelease];
    dashboardMainTemplateDataObject01.IUR = 20;
    dashboardMainTemplateDataObject01.text = @"b";
    dashboardMainTemplateDataObject01.horizontalAlignment = 1;
    dashboardMainTemplateDataObject01.verticalAlignment = 1;
    dashboardMainTemplateDataObject01.buttonType = 0;
    [row0 addObject:dashboardMainTemplateDataObject01];
    DashboardMainTemplateDataObject* dashboardMainTemplateDataObject02 = [[[DashboardMainTemplateDataObject alloc] createInstance:660 yPos:10 width:280 height:90] autorelease];
    dashboardMainTemplateDataObject02.IUR = 30;
    dashboardMainTemplateDataObject02.text = @"c";
    dashboardMainTemplateDataObject02.horizontalAlignment = 2;
    dashboardMainTemplateDataObject02.verticalAlignment = 2;
    dashboardMainTemplateDataObject02.buttonType = 0;
    [row0 addObject:dashboardMainTemplateDataObject02];
//    NSMutableArray* row1 = [NSMutableArray arrayWithCapacity:1];
    DashboardMainTemplateDataObject* dashboardMainTemplateDataObject10 = [[[DashboardMainTemplateDataObject alloc] createInstance:10 yPos:120 width:150 height:90] autorelease];
    dashboardMainTemplateDataObject10.IUR = 40;
    dashboardMainTemplateDataObject10.text = @"d";
    dashboardMainTemplateDataObject10.horizontalAlignment = 2;
    dashboardMainTemplateDataObject10.verticalAlignment = 2;
    dashboardMainTemplateDataObject10.buttonType = 0;
    [row0 addObject:dashboardMainTemplateDataObject10];    
//    NSMutableArray* row2 = [NSMutableArray arrayWithCapacity:1];
    DashboardMainTemplateDataObject* dashboardMainTemplateDataObject20 = [[[DashboardMainTemplateDataObject alloc] createInstance:150 yPos:240 width:200 height:120] autorelease];
    dashboardMainTemplateDataObject20.IUR = 50;
    dashboardMainTemplateDataObject20.text = @"e";
    dashboardMainTemplateDataObject20.horizontalAlignment = 2;
    dashboardMainTemplateDataObject20.verticalAlignment = 1;
    dashboardMainTemplateDataObject20.buttonType = 1;
    dashboardMainTemplateDataObject20.imageIUR = 1;
    [row0 addObject:dashboardMainTemplateDataObject20];
    [self.displayList addObject:row0];
//    [self.displayList addObject:row1];
//    [self.displayList addObject:row2];
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

@end
