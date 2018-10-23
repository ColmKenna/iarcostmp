//
//  PaginatedRequestObjectProvider.m
//  Arcos
//
//  Created by David Kilmartin on 20/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PaginatedRequestObjectProvider.h"

@implementation PaginatedRequestObjectProvider
@synthesize productPaginatedRequestField = _productPaginatedRequestField;
@synthesize pricePaginatedRequestField = _pricePaginatedRequestField;
@synthesize descrDetailsPaginatedRequestField = _descrDetailsPaginatedRequestField;
@synthesize locationPaginatedRequestField = _locationPaginatedRequestField;
@synthesize locLocLinkPaginatedRequestField = _locLocLinkPaginatedRequestField;
@synthesize contactPaginatedRequestField = _contactPaginatedRequestField;
@synthesize conLocLinkPaginatedRequestField = _conLocLinkPaginatedRequestField;
@synthesize imagePaginatedRequestField = _imagePaginatedRequestField;
@synthesize utilitiesUpdateDetailDataManager = _utilitiesUpdateDetailDataManager;
@synthesize formRowPaginatedRequestField = _formRowPaginatedRequestField;
@synthesize locationProductMATPaginatedRequestField = _locationProductMATPaginatedRequestField;

- (void)dealloc {
    if (self.productPaginatedRequestField != nil) { self.productPaginatedRequestField = nil; }
    self.pricePaginatedRequestField = nil;
    if (self.descrDetailsPaginatedRequestField != nil) { self.descrDetailsPaginatedRequestField = nil; }        
    if (self.locationPaginatedRequestField != nil) { self.locationPaginatedRequestField = nil; }
    self.locLocLinkPaginatedRequestField = nil;
    if (self.contactPaginatedRequestField != nil) { self.contactPaginatedRequestField = nil; }    
    if (self.conLocLinkPaginatedRequestField != nil) { self.conLocLinkPaginatedRequestField = nil; }
    if (self.imagePaginatedRequestField != nil) { self.imagePaginatedRequestField = nil; }
    if (self.utilitiesUpdateDetailDataManager != nil) { self.utilitiesUpdateDetailDataManager = nil; }
    if (self.formRowPaginatedRequestField != nil) { self.formRowPaginatedRequestField = nil; }      
    self.locationProductMATPaginatedRequestField = nil;
    
    [super dealloc];
}

- (PaginatedRequestObject*)descrDetailsRequestObject {
//    if (self.descrDetailsPaginatedRequestField != nil) {
//        return self.descrDetailsPaginatedRequestField;
//    }
    NSString* employeeSqlStatement = @"";
    NSString* fullEmployeeSqlStatement = @"";
    NSString* partialEmployeeSqlStatement = @"";
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
        int employeeIur = [[SettingManager employeeIUR] intValue];
        employeeSqlStatement = [NSString stringWithFormat:@" ForDetailing = 0 or ( ForDetailing = 1 and iur in (select descrdetailiur from DescrDetailLink where linkiur = %d)) ", employeeIur];
        fullEmployeeSqlStatement = [NSString stringWithFormat:@" where %@", employeeSqlStatement];
        partialEmployeeSqlStatement = [NSString stringWithFormat:@" and %@", employeeSqlStatement];
    }
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].descrDetailSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.descrDetailsPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    NSString* selectStatement = @"Select Iur,DescrTypeCode,Details,DescrDetailCode,ImageIUR,ForDetailing,ProfileOrder,Active,ParentCode,DetailingFiles,CodeType,Tooltip,Toggle1";
    NSString* fromStatement = [NSString stringWithFormat:@"from DescrDetail %@", fullEmployeeSqlStatement];
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        fromStatement = [NSString stringWithFormat:@"from DescrDetail where DateLastModified >= convert(datetime, '%@', 103) %@", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat], partialEmployeeSqlStatement];
    }
    NSString* orderBy = @"order by Iur";
    self.descrDetailsPaginatedRequestField.selectStateMent = selectStatement;
    self.descrDetailsPaginatedRequestField.fromStatement = fromStatement;
    self.descrDetailsPaginatedRequestField.orderBy = orderBy;
    
    return self.descrDetailsPaginatedRequestField;
}

- (PaginatedRequestObject*)productRequestObject {
//    if (self.productPaginatedRequestField != nil) {
//        return self.productPaginatedRequestField;
//    }
//    NSIndexPath* selectorIndexPath = [self.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:@"Product"];
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].productSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    
    self.productPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:3];
    NSNumber* active = [activeOnly objectForKey:@"Value"];
    NSString* selectStatement = @"Select IUR,ProductCode,Description,L1Code,L2Code,L3Code,L4Code,L5Code,UnitTradePrice,Active,Productsize,UnitsPerPack,ForDetailing,SamplesAvailable,ForSampling,ScoreProcedure,BonusBy,StockAvailable,OrderPadDetails,ImageIUR,BonusGiven,BonusRequired,SellBy,BonusMinimum,EAN,FlagIUR,MinimumUnitPrice,PackEAN,UnitRRP,UnitManufacturerPrice,UnitRevenueAmount,AdvertFiles,DetailingFiles,PackFiles,POSFiles,RadioFiles";
    NSString* fromStatement = nil;
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([active intValue] == 1) {
            fromStatement = [NSString stringWithFormat:@"from Product where active = 1 and DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {            
            fromStatement = [NSString stringWithFormat:@"from Product where DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }
    } else {
        if ([active intValue] == 1) {
            fromStatement = @"from Product where active = 1";
        } else {
            //        fromStatement = @"from iPadProductDetails";
            fromStatement = @"from Product where IUR != 0";
        }
    }
    
    
    NSString* orderBy = @"order by iur";
    self.productPaginatedRequestField.selectStateMent = selectStatement;
    self.productPaginatedRequestField.fromStatement = fromStatement;
    self.productPaginatedRequestField.orderBy = orderBy;    
    return self.productPaginatedRequestField;
}

- (PaginatedRequestObject*)priceRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].priceSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    
    //own location only
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@", @"Download"];
    NSMutableDictionary* ownLocationOnly = [sm getSettingForKeypath:keypath atIndex:0];
    NSNumber* ownLocation = [ownLocationOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee = [sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR = [empolyee objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownLocation boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    self.pricePaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    NSString* selectStatement = @"SELECT Price.IUR, Price.LocationIUR, Price.ProductIUR, Price.PGiur, Price.UnitTradePrice, Price.MinimumUnitPrice, Price.CurrenyIUR, Price.DiscountPercent, Price.RebatePercent, Price.AllowFree, Price.BonusDeal";
    NSString* fromStatement = nil;
    
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"from Price INNER JOIN LocEmpLink ON Price.LocationIUR = LocEmpLink.LocationIUR WHERE (LocEmpLink.EmployeeIUR = %d) AND DateLastModified >= convert(datetime, '%@', 103)", anEmpolyeeIUR, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
            fromStatement = [NSString stringWithFormat:@"from Price where Price.DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }        
    } else {
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"from Price INNER JOIN LocEmpLink ON Price.LocationIUR = LocEmpLink.LocationIUR WHERE (LocEmpLink.EmployeeIUR = %d)", anEmpolyeeIUR];
        } else {
            fromStatement = @"from Price";
        }        
    }    
    NSString* orderBy = @"order by Price.IUR";
    
    self.pricePaginatedRequestField.selectStateMent = selectStatement;
    self.pricePaginatedRequestField.fromStatement = fromStatement;
    self.pricePaginatedRequestField.orderBy = orderBy;
    return self.pricePaginatedRequestField;
}

- (PaginatedRequestObject*)locationRequestObject {
//    if (self.locationPaginatedRequestField != nil) {
//        return self.locationPaginatedRequestField;
//    }
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.locationPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSString* activeFilterLocation_1 = @" OR Location.Active = 0";
    NSString* activeFilterLocation_2 = @" OR Location_2.Active = 0";    
    
    //own location only
    NSMutableDictionary* ownLocationOnly=[sm getSettingForKeypath:keypath atIndex:0];
    NSNumber* ownLocation = [ownLocationOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    //Active location only
    NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:2];
    NSNumber* active = [activeOnly objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownLocation boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    if ([active boolValue]) {
        activeFilterLocation_1 = @"";
        activeFilterLocation_2 = @"";
    }
    
    NSString* whereClause = [NSString stringWithFormat:@"where Location.iur != 0 and (DescrDetail.DescrDetailCode = 'Whol' or DescrDetail.DescrDetailCode = 'BUGR' or LocEmpLink.EmployeeIUR = %d) and ((Location.Active = 1 %@) or location_1.iur != 0)", anEmpolyeeIUR, activeFilterLocation_1];
    
//    NSString* whereClause_2 = [NSString stringWithFormat:@"WHERE LocEmpLink_1.EmployeeIUR = %d AND (Location_2.Active = 1 %@)", anEmpolyeeIUR, activeFilterLocation_2];
    
    NSString* selectStatement = @"SELECT IUR, LocationCode, Name, ShortName, Address1, Address2, Address3, Address4, PhoneNumber, FaxNumber, CCiur, TCiur, CSiur, LTiur, LSiur, LP01,Latitude, Longitude, Active, MasterLocationIUR, ImageIUR, Email, Password, RouteNumber, OutstandingBalance, AgedAmount1, AgedAmount2, AgedAmount3, AgedAmount4,LP02,LP03,LP04,LP05,LP06,LP07,LP08,LP09,LP10,AccessTimes,PGIUR,PriceOverride,CUiur";

    NSString* fromStatement = @"";
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  Location WHERE (IUR IN (SELECT    distinct Location.IUR FROM Location INNER JOIN Location AS Location_1 ON Location.IUR = Location_1.IUR OR Location.IUR = Location_1.MasterLocationIUR INNER JOIN LocEmpLink ON Location_1.IUR = LocEmpLink.LocationIUR INNER JOIN DescrDetail ON Location_1.LTiur = DescrDetail.IUR %@ )) and DateLastModified >= convert(datetime, '%@', 103)", whereClause, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
            if ([active boolValue]) {
                fromStatement = [NSString stringWithFormat:@"FROM  Location WHERE Location.iur != 0 And Location.Active = 1 and DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
            } else {
                fromStatement = [NSString stringWithFormat:@"FROM  Location WHERE Location.iur != 0 and DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
            }        
        }
    } else {
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  Location WHERE (IUR IN (SELECT    distinct Location.IUR FROM Location INNER JOIN Location AS Location_1 ON Location.IUR = Location_1.IUR OR Location.IUR = Location_1.MasterLocationIUR INNER JOIN LocEmpLink ON Location_1.IUR = LocEmpLink.LocationIUR INNER JOIN DescrDetail ON Location_1.LTiur = DescrDetail.IUR %@ )) ", whereClause];
        } else {
            if ([active boolValue]) {
                fromStatement = @"FROM  Location WHERE Location.iur != 0 And Location.Active = 1";
            } else {
                fromStatement = @"FROM  Location WHERE Location.iur != 0";
            }        
        }
    }
    
        
    NSString* orderBy = @"ORDER BY IUR";
    self.locationPaginatedRequestField.selectStateMent = selectStatement;
    self.locationPaginatedRequestField.fromStatement = fromStatement;
    self.locationPaginatedRequestField.orderBy = orderBy;
    return self.locationPaginatedRequestField;
}

- (PaginatedRequestObject*)locLocLinkRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].locLocLinkSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.locLocLinkPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSString* activeFilterLocation_1 = @" OR Location.Active = 0";
    NSString* activeFilterLocation_2 = @" OR Location_2.Active = 0";
    
    //own location only
    NSMutableDictionary* ownLocationOnly=[sm getSettingForKeypath:keypath atIndex:0];
    NSNumber* ownLocation = [ownLocationOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    //Active location only
    NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:2];
    NSNumber* active = [activeOnly objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownLocation boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    if ([active boolValue]) {
        activeFilterLocation_1 = @"";
        activeFilterLocation_2 = @"";
    }
    
    NSString* whereClause = [NSString stringWithFormat:@"where Location.iur != 0 and (DescrDetail.DescrDetailCode = 'Whol' or DescrDetail.DescrDetailCode = 'BUGR' or LocEmpLink.EmployeeIUR = %d) and ((Location.Active = 1 %@) or location_1.iur != 0)", anEmpolyeeIUR, activeFilterLocation_1];
    
    //    NSString* whereClause_2 = [NSString stringWithFormat:@"WHERE LocEmpLink_1.EmployeeIUR = %d AND (Location_2.Active = 1 %@)", anEmpolyeeIUR, activeFilterLocation_2];
    
    NSString* selectStatement = @"SELECT IUR, LocationIUR, FromLocationIUR, CustomerCode, LinkType";
    
    NSString* fromStatement = @"";
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  LocLocLink WHERE (LocationIUR IN (SELECT    distinct Location.IUR FROM Location INNER JOIN Location AS Location_1 ON Location.IUR = Location_1.IUR OR Location.IUR = Location_1.MasterLocationIUR INNER JOIN LocEmpLink ON Location_1.IUR = LocEmpLink.LocationIUR INNER JOIN DescrDetail ON Location_1.LTiur = DescrDetail.IUR %@  and Location.DateLastModified >= convert(datetime, '%@', 103)))", whereClause, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
            if ([active boolValue]) {
                fromStatement = [NSString stringWithFormat:@"FROM LocLocLink WHERE (IUR IN (SELECT LocLocLink_2.IUR FROM LocLocLink AS LocLocLink_2 INNER JOIN Location AS Location_1 ON LocLocLink_2.LocationIUR = Location_1.IUR and Location_1.iur != 0 And Location_1.Active = 1 and Location_1.DateLastModified >= convert(datetime, '%@', 103))) ", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
            } else {
                fromStatement = [NSString stringWithFormat:@"FROM LocLocLink WHERE (IUR IN (SELECT LocLocLink_2.IUR FROM LocLocLink AS LocLocLink_2 INNER JOIN Location AS Location_1 ON LocLocLink_2.LocationIUR = Location_1.IUR and Location_1.iur != 0 and Location_1.DateLastModified >= convert(datetime, '%@', 103))) ", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
            }
        }
    } else {
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM LocLocLink WHERE (LocationIUR IN   (SELECT distinct Location.IUR FROM Location INNER JOIN Location AS Location_1 ON Location.IUR = Location_1.IUR OR Location.IUR = Location_1.MasterLocationIUR INNER JOIN LocEmpLink ON Location_1.IUR = LocEmpLink.LocationIUR INNER JOIN DescrDetail ON Location_1.LTiur = DescrDetail.IUR %@ )) ", whereClause];
        } else {
            if ([active boolValue]) {
                fromStatement = @"FROM LocLocLink WHERE (IUR IN (SELECT LocLocLink_2.IUR FROM LocLocLink AS LocLocLink_2 INNER JOIN Location AS Location_1 ON LocLocLink_2.LocationIUR = Location_1.IUR WHERE Location_1.iur != 0 And Location_1.Active = 1))";
            } else {
                fromStatement = @"FROM LocLocLink WHERE LocLocLink.IUR != 0";
            }
        }
    }
    
    NSString* orderBy = @"ORDER BY IUR";
    self.locLocLinkPaginatedRequestField.selectStateMent = selectStatement;
    self.locLocLinkPaginatedRequestField.fromStatement = fromStatement;
    self.locLocLinkPaginatedRequestField.orderBy = orderBy;
    return self.locLocLinkPaginatedRequestField;
}

- (PaginatedRequestObject*)contactRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].contactSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.contactPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    //own location only
    NSMutableDictionary* ownContactOnly=[sm getSettingForKeypath:keypath atIndex:1];
    NSNumber* ownContact = [ownContactOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownContact boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    NSString* selectStatement = @"SELECT IUR, SecondIUR, Forename, Surname, Email, Initial, InitialIUR, Memoiur, MobileNumber, PhoneNumber, CLiur, Active, COiur, CP01, CP02, CP03, CP04, CP05, CP06, CP07, CP08, CP09, CP10, AccessTimes, LinkedContactIUR";
    NSString* fromStatement = @"";
    
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownContact boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  Contact WHERE (IUR IN (SELECT Contact_2.IUR FROM   Contact AS Contact_2 INNER JOIN ConEmpLink AS ConEmpLink_1 ON Contact_2.IUR = ConEmpLink_1.ContactIUR WHERE ConEmpLink_1.EmployeeIUR = %d AND Contact_2.Active = 1)) and DateLastModified >= convert(datetime, '%@', 103)", anEmpolyeeIUR, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
            fromStatement = [NSString stringWithFormat:@"FROM  Contact WHERE Active = 1 and DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }
    } else {
        if ([ownContact boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  Contact WHERE (IUR IN (SELECT Contact_2.IUR FROM   Contact AS Contact_2 INNER JOIN ConEmpLink AS ConEmpLink_1 ON Contact_2.IUR = ConEmpLink_1.ContactIUR WHERE ConEmpLink_1.EmployeeIUR = %d AND Contact_2.Active = 1))", anEmpolyeeIUR];
        } else {
            fromStatement = @"FROM  Contact WHERE Active = 1";
        }    
    }
    
    NSString* orderBy = @"ORDER BY IUR";
    self.contactPaginatedRequestField.selectStateMent = selectStatement;
    self.contactPaginatedRequestField.fromStatement = fromStatement;
    self.contactPaginatedRequestField.orderBy = orderBy;  
    return self.contactPaginatedRequestField;
}

- (PaginatedRequestObject*)conLocLinkRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].conLocLinkSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.conLocLinkPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    //own location only
    NSMutableDictionary* ownContactOnly=[sm getSettingForKeypath:keypath atIndex:1];
    NSNumber* ownContact = [ownContactOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownContact boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    NSString* selectStatement = @"SELECT IUR, ContactIUR, LocationIUR, DefaultContact, DefaultLocation";
    NSString* fromStatement = @"";
    
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownContact boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM  ConLocLink WHERE (IUR IN (SELECT ConLocLink_2.IUR FROM   ConLocLink AS ConLocLink_2 INNER JOIN ConEmpLink AS ConEmpLink_1 ON ConLocLink_2.ContactIUR = ConEmpLink_1.ContactIUR INNER JOIN Contact AS Contact_1 ON ConLocLink_2.ContactIUR = Contact_1.IUR  WHERE ConEmpLink_1.EmployeeIUR = %d and Contact_1.Active = 1 and Contact_1.DateLastModified >= convert(datetime, '%@', 103))) ", anEmpolyeeIUR, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
//            fromStatement = [NSString stringWithFormat:@"FROM ConLocLink INNER JOIN Contact AS Contact_1 ON ConLocLink.ContactIUR = Contact_1.IUR where Contact_1.DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
            fromStatement = [NSString stringWithFormat:@"FROM ConLocLink WHERE (IUR IN (SELECT ConLocLink_2.IUR FROM   ConLocLink AS ConLocLink_2 INNER JOIN Contact AS Contact_1 ON ConLocLink_2.ContactIUR = Contact_1.IUR  WHERE Contact_1.Active = 1 and  Contact_1.DateLastModified >= convert(datetime, '%@', 103))) ", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }
    } else {
        if ([ownContact boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM ConLocLink WHERE (IUR IN (SELECT ConLocLink_2.IUR FROM   ConLocLink AS ConLocLink_2 INNER JOIN ConEmpLink AS ConEmpLink_1 ON ConLocLink_2.ContactIUR = ConEmpLink_1.ContactIUR INNER JOIN Contact AS Contact_1 ON ConLocLink_2.ContactIUR = Contact_1.IUR WHERE ConEmpLink_1.EmployeeIUR = %d and Contact_1.Active = 1))", anEmpolyeeIUR];
        } else {
            fromStatement = @"FROM ConLocLink WHERE (IUR IN (SELECT ConLocLink_2.IUR FROM   ConLocLink AS ConLocLink_2 INNER JOIN Contact AS Contact_1 ON ConLocLink_2.ContactIUR = Contact_1.IUR WHERE Contact_1.Active = 1))";
        }
    }
    
    NSString* orderBy = @"ORDER BY IUR";
    self.conLocLinkPaginatedRequestField.selectStateMent = selectStatement;
    self.conLocLinkPaginatedRequestField.fromStatement = fromStatement;
    self.conLocLinkPaginatedRequestField.orderBy = orderBy;  
    return self.conLocLinkPaginatedRequestField;
}

- (PaginatedRequestObject*)imageRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].imageSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.imagePaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    NSString* selectStatement = @"SELECT IUR, Title, Filename, Thumbnail";
    NSString* fromStatement = @"FROM  Image";
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        fromStatement = [NSString stringWithFormat:@"from Image where DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
    }
    NSString* orderBy = @"ORDER BY IUR";
    self.imagePaginatedRequestField.selectStateMent = selectStatement;
    self.imagePaginatedRequestField.fromStatement = fromStatement;
    self.imagePaginatedRequestField.orderBy = orderBy;
    return self.imagePaginatedRequestField;
}

- (NSMutableDictionary*)getUpdateCenterDataDict:(NSString*)aSelectorName {
    NSIndexPath* selectorIndexPath = [self.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:aSelectorName];
    return [self.utilitiesUpdateDetailDataManager.dataTablesDisplayList objectAtIndex:selectorIndexPath.section];
}

- (PaginatedRequestObject*)formRowRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].formRowSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    
    self.formRowPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:4];
    NSNumber* active = [activeOnly objectForKey:@"Value"];
    NSString* selectStatement = @"Select Iur,FormIUR,ProductIUR,Details,SequenceNumber,SequenceDivider,UnitPrice,Level5IUR,DefaultQty,DefaultPercent";
    NSString* fromStatement = nil;
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([active intValue] == 1) {
            fromStatement = [NSString stringWithFormat:@"from FormRow where (IUR IN (SELECT FormRow_2.IUR FROM FormRow AS FormRow_2 INNER JOIN FormDetail AS FormDetail_1 ON FormRow_2.FormIUR = FormDetail_1.IUR WHERE FormDetail_1.Active = 1)) and DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {            
            fromStatement = [NSString stringWithFormat:@"from FormRow where DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }
    } else {
        if ([active intValue] == 1) {
            fromStatement = @"from FormRow where (IUR IN (SELECT FormRow_2.IUR FROM FormRow AS FormRow_2 INNER JOIN FormDetail AS FormDetail_1 ON FormRow_2.FormIUR = FormDetail_1.IUR WHERE FormDetail_1.Active = 1))";
        } else {
            fromStatement = @"from FormRow";
        }
    }    
    NSString* orderBy = @"order by iur";
    self.formRowPaginatedRequestField.selectStateMent = selectStatement;
    self.formRowPaginatedRequestField.fromStatement = fromStatement;
    self.formRowPaginatedRequestField.orderBy = orderBy;    
    return self.formRowPaginatedRequestField;
}

- (PaginatedRequestObject*)locationProductMATRequestObject {
    NSMutableDictionary* dataDict = [self getUpdateCenterDataDict:[GlobalSharedClass shared].locationProductMATSelectorName];
    NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
    NSNumber* isDownloaded = [dataDict objectForKey:@"IsDownloaded"];
    self.locationProductMATPaginatedRequestField = [[[PaginatedRequestObject alloc] init] autorelease];
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    //own location only
    NSMutableDictionary* ownLocationOnly = [sm getSettingForKeypath:keypath atIndex:0];
    NSNumber* ownLocation = [ownLocationOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee = [sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR = [empolyee objectForKey:@"Value"];
    int anEmpolyeeIUR = 0;
    if ([ownLocation boolValue]) {
        anEmpolyeeIUR = [empolyeeIUR intValue];
    }
    
    NSString* selectStatement = @"SELECT LocationIUR,ProductIUR,Qty01,Qty02,Qty03,Qty04,Qty05,Qty06,Qty07,Qty08,Qty09,Qty10,Qty11,Qty12,Qty13,Qty14,Qty15,Qty16,Qty17,Qty18,Qty19,Qty20,Qty21,Qty22,Qty23,Qty24,Qty25,Bonus01,Bonus02,Bonus03,Bonus04,Bonus05,Bonus06,Bonus07,Bonus08,Bonus09,Bonus10,Bonus11,Bonus12,Bonus13,Bonus14,Bonus15,Bonus16,Bonus17,Bonus18,Bonus19,Bonus20,Bonus21,Bonus22,Bonus23,Bonus24,Bonus25,Sales01,Sales02,Sales03,Sales04,Sales05,Sales06,Sales07,Sales08,Sales09,Sales10,Sales11,Sales12,Sales13,Sales14,Sales15,Sales16,Sales17,Sales18,Sales19,Sales20,Sales21,Sales22,Sales23,Sales24,Sales25,InStock,CONVERT(VARCHAR(10),DateLastModified,103) as DateLastModified";
//    NSString* selectStatement = @"SELECT LocationIUR,ProductIUR,Qty13,Qty14,Qty15,Qty16,Qty17,Qty18,Qty19,Qty20,Qty21,Qty22,Qty23,Qty24,Qty25,InStock,CONVERT(VARCHAR(10),DateLastModified,103)";
    NSString* fromStatement = nil;
    if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
        NSDate* downloadDate = [dataDict objectForKey:@"DownloadDate"];
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM LocationProductMAT WHERE (LocationIUR IN (SELECT LocationProductMAT_2.LocationIUR FROM LocationProductMAT AS LocationProductMAT_2 INNER JOIN LocEmpLink AS LocEmpLink_1 ON LocationProductMAT_2.LocationIUR = LocEmpLink_1.LocationIUR WHERE LocEmpLink_1.EmployeeIUR = %d)) AND DateLastModified >= convert(datetime, '%@', 103)", anEmpolyeeIUR, [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        } else {
            fromStatement = [NSString stringWithFormat:@"FROM LocationProductMAT WHERE DateLastModified >= convert(datetime, '%@', 103)", [ArcosUtils stringFromDate:downloadDate format:[GlobalSharedClass shared].dateFormat]];
        }
    } else {
        if ([ownLocation boolValue]) {
            fromStatement = [NSString stringWithFormat:@"FROM LocationProductMAT WHERE (LocationIUR IN (SELECT LocationProductMAT_2.LocationIUR FROM LocationProductMAT AS LocationProductMAT_2 INNER JOIN LocEmpLink AS LocEmpLink_1 ON LocationProductMAT_2.LocationIUR = LocEmpLink_1.LocationIUR WHERE LocEmpLink_1.EmployeeIUR = %d))", anEmpolyeeIUR];
        } else {
            fromStatement = @"FROM LocationProductMAT";
        }
    }
    
    
    NSString* orderBy = @"order by LocationIUR,ProductIUR";
    self.locationProductMATPaginatedRequestField.selectStateMent = selectStatement;
    self.locationProductMATPaginatedRequestField.fromStatement = fromStatement;
    self.locationProductMATPaginatedRequestField.orderBy = orderBy;
    
    return self.locationProductMATPaginatedRequestField;
}

@end
