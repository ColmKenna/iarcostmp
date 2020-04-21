//
//  SettingManager.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingManager.h"

@interface SettingManager (Private)

@end 

@implementation SettingManager

@synthesize settingDict;

-(id)init{
    self=[super init];
    if (self!=nil) {
        if (![FileCommon settingFileExist]) {
            [self loadDefaultFromBoundle];
            //[self loadDefaultSetting];
        }else{
            [self loadSetting];
        }
    }
    return self;
}
+(id)setting{
    return [[[self alloc]init]autorelease];
}
-(BOOL)loadSetting{
    self.settingDict=[NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon settingFilePath]];    
    if (self.settingDict==nil) {
        return NO;
    }
    @try {        
        NSString* keypath = @"PersonalSetting.Personal";
        NSMutableArray* items=[self.settingDict valueForKeyPath:keypath];
        NSMutableDictionary* item = [items objectAtIndex:0];
        NSString* labelValue = [item objectForKey:@"Label"];
        if (![labelValue isEqualToString:@"EmployeeIUR"]) {
            [item setObject:@"EmployeeIUR" forKey:@"Label"];
            [items replaceObjectAtIndex:0 withObject:item];
            [self.settingDict setValue:items forKeyPath:keypath];
            [self saveSetting];
        }        
    }
    @catch (NSException *exception) {
        NSLog(@"%@ : %@", exception.name, exception.reason);
    }
    
    return YES;
}
-(BOOL)saveSetting{
    BOOL isSuccess=[self.settingDict writeToFile:[FileCommon settingFilePath] atomically:YES];

    return isSuccess;
}
-(BOOL)updateSettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index withData:(id)data{
    NSMutableArray* items=[self.settingDict valueForKeyPath:keypath];
    NSMutableDictionary* item=[items objectAtIndex:index];
    [item setObject:data forKey:@"Value"];
    [items replaceObjectAtIndex:index withObject:item];
    [self.settingDict setValue:items forKeyPath:keypath];
    return YES;
}
-(id)getSettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index{
    NSMutableArray* items=[self.settingDict valueForKeyPath:keypath];
    NSMutableDictionary* item=[items objectAtIndex:index];
    //NSLog(@"setting dice is in keypath %@ %@",keypath, self.settingDict);
    return item;
}
-(NSUInteger)numberOfItemsOnKeypath:(NSString*)keypath{
    NSMutableArray* items=[self.settingDict valueForKeyPath:keypath];
    if (items==nil) {
        return 0;
    }else{
        return [items count];
    }
}
-(NSArray*)keysForSettingCat:(NSString*)settingCat{
    NSMutableDictionary* items=[self.settingDict valueForKeyPath:settingCat];
    if (items==nil) {
        return [NSArray array];
    }else{
        return [items allKeys];
    }
}
-(BOOL)loadDefaultFromBoundle{
    NSBundle* bundle = [NSBundle mainBundle];
	NSString* plistPath = [bundle pathForResource:@"defaultSetting" ofType:@"plist"];
    
	NSMutableDictionary* defaultSetting = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    self.settingDict=defaultSetting;
//    NSLog(@"setting file dict is %@",self.settingDict);
    
    [self.settingDict writeToFile:[FileCommon settingFilePath] atomically:YES];

    return YES;
}
-(BOOL)loadDefaultSetting{
    /*settting types
        0  string type
        1  number type
        2  switch type
        3  selection type
     */
    
    NSMutableDictionary* defaultSetting=[NSMutableDictionary dictionary];
    
    
    //compnay setting connection group
    NSMutableArray* connectionItems=[NSMutableArray array];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"SettingType",[NSNumber numberWithInt:0],@"Value",@"CompanyIUR",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value",@"Host Location",@"Label", nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value",@"Database Name",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value", @"Database Username",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value", @"Database Password",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value", @"PresenterURL",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value", @"Presenter Username",@"Label",nil]];
    [connectionItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"SettingType",[NSString string],@"Value", @"Presenter Password",@"Label",nil]];
    
    NSMutableDictionary* companySetting=[NSMutableDictionary dictionaryWithObject:connectionItems forKey:@"Connection"];
    
    //compnay setting download group
    NSMutableArray* downloadItems=[NSMutableArray array];

    [downloadItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Own Locations Only",@"Label",nil]];
    [downloadItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Own Contact Only",@"Label",nil]];
    [downloadItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Active Locations Only",@"Label",nil]];
    [downloadItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Active Products Only",@"Label",nil]];
    [downloadItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Active Forms Only",@"Label",nil]];
    [companySetting setObject:downloadItems forKey:@"Download"];
    
    //compnay setting connection group
    NSMutableArray* defaultTypesItems=[NSMutableArray array];

    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value",@"Location Type",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Contact Type",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Call Type",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Order Status",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Order Type",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Sent Order Status",@"Label",nil]];
    [defaultTypesItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Wholesaler Type IUR",@"Label",nil]];
    [companySetting setObject:defaultTypesItems forKey:@"Default Types"];
    
    //company setting processing
    NSMutableArray* orderProcessingItems=[NSMutableArray array];

    [orderProcessingItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Send Transfer Orders",@"Label",nil]];
    [orderProcessingItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"SettingType",[NSNumber numberWithBool:NO],@"Value", @"Allow Discount",@"Label",nil]];
    [companySetting setObject:orderProcessingItems forKey:@"Order Processing"];
    
    //personal setting
    NSMutableArray* personalItems=[NSMutableArray array];

    [personalItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Target Value for Week",@"Label",nil]];
    [personalItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Target Value for Month",@"Label",nil]];
    [personalItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"Target Value for Year",@"Label",nil]];
    [personalItems addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"SettingType",[NSNumber numberWithInt:0],@"Value", @"EmplyeeIUR",@"Label",nil]];
    NSMutableDictionary* personalSetting=[NSMutableDictionary dictionaryWithObject:personalItems forKey:@"Personal"];


    [defaultSetting setValue:companySetting forKey:@"CompanySetting"];
    [defaultSetting setValue:personalSetting forKey:@"PersonalSetting"];

    self.settingDict=defaultSetting;
//    NSLog(@"setting file dict is %@",self.settingDict);
    [self.settingDict writeToFile:[FileCommon settingFilePath] atomically:YES];
    return YES;
}
-(BOOL)reloadSetting{
    [self loadSetting];
    return YES;
}
#pragma mark static method
+(NSNumber*)DisplayInactiveRecord{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* item=[sm getSettingForKeypath:@"CompanySetting.Display" atIndex:0];
    return [item objectForKey:@"Value"];
}
+(NSNumber*)NextOrderNumber{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* item=[sm getSettingForKeypath:@"CompanySetting.Order Processing" atIndex:2];
    
    NSLog(@"order number  is %@",[item objectForKey:@"Value"]);
    NSNumber* orderNumber=[NSNumber numberWithInt: [[item objectForKey:@"Value"]intValue]];
    
    //increse the order number
    NSNumber* increasedNumber=[NSNumber numberWithInt: [orderNumber intValue]+1];
    [sm updateSettingForKeypath:@"CompanySetting.Order Processing" atIndex:2 withData:increasedNumber];
    [sm saveSetting];
    
    return orderNumber;
}
+(void)SetNextOrderNumber:(NSNumber*)number{
    SettingManager* sm=[SettingManager setting];

    if (number==nil) {
        return;
    }
    if ([number intValue]==0) {
        return;
    }
    
    [sm updateSettingForKeypath:@"CompanySetting.Order Processing" atIndex:2 withData:number];
    [sm saveSetting];
}
+(NSNumber*)SettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* item=[sm getSettingForKeypath:keypath atIndex:index];
    return [item objectForKey:@"Value"];
}

+(NSNumber*)companyIUR{
    SettingManager* sm=[SettingManager setting];
    NSString* keypath=[NSString stringWithFormat:@"CompanySetting.%@",@"Connection"];
    NSMutableDictionary* companyIUR=[sm getSettingForKeypath:keypath atIndex:0];
    return [companyIUR objectForKey:@"Value"];
}
+(NSNumber*)employeeIUR{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    return [empolyee objectForKey:@"Value"];
}
+(NSString*)downloadServer{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* serverLocation=[sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:6];
    return [serverLocation objectForKey:@"Value"];
}
+(NSString*)serviceAddress{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* serverLocation=[sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:1];
    return [serverLocation objectForKey:@"Value"];
}
+(NSString*)hostAddress{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* serverLocation=[sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:2];
    return [serverLocation objectForKey:@"Value"];
}
+(NSNumber*)defaultOrderSentStatus{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* sentOrderStatus=[sm getSettingForKeypath:@"CompanySetting.Default Types" atIndex:5];
    return [sentOrderStatus objectForKey:@"Value"];
}
+(BOOL)restrictOrderForm {
    return NO;
}
+(NSString*)arcosAdminEmail {
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* arcosAdminEmailDict=[sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:7];
    return [arcosAdminEmailDict objectForKey:@"Value"];
}
+(NSString*)databaseName {
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* databaseNameDict=[sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:3];
    return [[databaseNameDict objectForKey:@"Value"] uppercaseString];
}

-(void)dealloc{    
    if (self.settingDict != nil) {
        [self.settingDict release];
    }
    [super dealloc];
}
@end
