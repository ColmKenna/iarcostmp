//
//  Config.h
//  Arcos
//
//  Created by David Kilmartin on 23/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Config : NSManagedObject

@property (nonatomic, retain) NSNumber * ShowproductCode;
@property (nonatomic, retain) NSNumber * ShoCatalogCode;
@property (nonatomic, retain) NSNumber * MergeBranchAccounts;
@property (nonatomic, retain) NSNumber * ForceSurvey;
@property (nonatomic, retain) NSNumber * DefaultCTIUR;
@property (nonatomic, retain) NSNumber * UseVAT;
@property (nonatomic, retain) NSNumber * MoveHistoricData;
@property (nonatomic, retain) NSNumber * DefauleLTiur;
@property (nonatomic, retain) NSNumber * UseTesters;
@property (nonatomic, retain) NSString * DefaultCustomerView;
@property (nonatomic, retain) NSNumber * DefaultFormIUR;
@property (nonatomic, retain) NSNumber * UseBonus;
@property (nonatomic, retain) NSNumber * UseFOC;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * TargetOnDeleveryDates;
@property (nonatomic, retain) NSNumber * PasswordExpireDays;
@property (nonatomic, retain) NSNumber * DefaultCUiur;
@property (nonatomic, retain) NSNumber * RecordDistribution;
@property (nonatomic, retain) NSNumber * NetSalesFormula;
@property (nonatomic, retain) NSNumber * UseLastEmployeeForm;
@property (nonatomic, retain) NSNumber * UpdateOutlook;
@property (nonatomic, retain) NSNumber * TargetVolumeIncludesBonus;
@property (nonatomic, retain) NSString * DefaultDataType;
@property (nonatomic, retain) NSNumber * UseCompantDiscount;
@property (nonatomic, retain) NSNumber * BlockOrderPad;
@property (nonatomic, retain) NSNumber * MinimumOrderValue;
@property (nonatomic, retain) NSNumber * showRemarks;
@property (nonatomic, retain) NSNumber * sageformIUR;
@property (nonatomic, retain) NSNumber * HQtoRep;
@property (nonatomic, retain) NSNumber * HasBackOrders;
@property (nonatomic, retain) NSNumber * DefaultSTiur;
@property (nonatomic, retain) NSNumber * ConfirmStockDelivery;
@property (nonatomic, retain) NSNumber * InvoiceDataAvailable;
@property (nonatomic, retain) NSNumber * BonusBlockedat;
@property (nonatomic, retain) NSNumber * ShowF6inOrderEntry;
@property (nonatomic, retain) NSNumber * SMSTexting;
@property (nonatomic, retain) NSNumber * BlockBonusOnly;
@property (nonatomic, retain) NSNumber * CashCollection;
@property (nonatomic, retain) NSNumber * HQtoSYS;
@property (nonatomic, retain) NSNumber * PrintOrder;
@property (nonatomic, retain) NSNumber * DefaultWholesalerIUR;
@property (nonatomic, retain) NSNumber * SYStoHQ;
@property (nonatomic, retain) NSNumber * DefaultNoOfPeriods;
@property (nonatomic, retain) NSString * F3Template;
@property (nonatomic, retain) NSNumber * DayofWeekend;
@property (nonatomic, retain) NSNumber * PrintFooterPage;
@property (nonatomic, retain) NSNumber * ApplyBonusStructure;
@property (nonatomic, retain) NSNumber * Emailing;
@property (nonatomic, retain) NSNumber * UseinStock;
@property (nonatomic, retain) NSNumber * AllYytdTYytdTY;
@property (nonatomic, retain) NSString * StandardLocationCode;
@property (nonatomic, retain) NSNumber * TargetEstimatesInUse;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * ShowlocationCode;
@property (nonatomic, retain) NSNumber * CompanyLocationIUR;
@property (nonatomic, retain) NSNumber * MaintainWholesalerCodes;
@property (nonatomic, retain) NSString * ClientHomePage;
@property (nonatomic, retain) NSNumber * RecordLeads;
@property (nonatomic, retain) NSString * DefaultDataSource;
@property (nonatomic, retain) NSNumber * LinkProductGroups;
@property (nonatomic, retain) NSNumber * PrintHeaderPage;
@property (nonatomic, retain) NSNumber * ForceAppointment;
@property (nonatomic, retain) NSNumber * allowstatuschange;
@property (nonatomic, retain) NSNumber * sageinuse;
@property (nonatomic, retain) NSNumber * DefaultTargetsize;
@property (nonatomic, retain) NSNumber * ForceWholesaler;
@property (nonatomic, retain) NSNumber * UseCustomerPricing;
@property (nonatomic, retain) NSNumber * seperateBonusLines;
@property (nonatomic, retain) NSNumber * DefaultProductLevel;
@property (nonatomic, retain) NSNumber * PointsSystemInUse;
@property (nonatomic, retain) NSNumber * Webenabled;
@property (nonatomic, retain) NSNumber * Overheads;
@property (nonatomic, retain) NSString * StrataHomePage;
@property (nonatomic, retain) NSNumber * ReptoHQ;
@property (nonatomic, retain) NSString * StandadProductCode;
@property (nonatomic, retain) NSNumber * ForceOrderType;
@property (nonatomic, retain) NSNumber * AskWholesaler;
@property (nonatomic, retain) NSNumber * OrderPadFromDiary;
@property (nonatomic, retain) NSNumber * AllowSplitPacks;
@property (nonatomic, retain) NSNumber * SplitDeliveryDates;

@end
