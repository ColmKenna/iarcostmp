//
//  LocationUM.m
//  Arcos
//
//  Created by David Kilmartin on 29/06/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "LocationUM.h"


@implementation LocationUM
@synthesize MasterLocationIUR;
@synthesize AgedAmount3;
@synthesize Email;
@synthesize LP04;
@synthesize LocationCode;
@synthesize EAN;
@synthesize LP010;
@synthesize BonusBlocker;
@synthesize RegisteredAddress3;
@synthesize SortKey;
@synthesize LP014;
@synthesize RegisteredName;
@synthesize IUR;
@synthesize FaxNumber;
@synthesize LP018;
@synthesize DialupNumber;
@synthesize AgedAmount4;
@synthesize CreditLimit;
@synthesize LP05;
@synthesize CUiur;
@synthesize CSiur;
@synthesize Active;
@synthesize LastPaymentDate;
@synthesize Tradingas;
@synthesize RegisteredAddress4;
@synthesize PhoneNumber;
@synthesize CompanyNumber;
@synthesize LP06;
@synthesize LP011;
@synthesize LP015;
@synthesize Competitor1;
@synthesize FormList;
@synthesize LocationIUR;
@synthesize LP019;
@synthesize LastPaymentAmount;
@synthesize LP07;
@synthesize VATNumber;
@synthesize Competitor2;
@synthesize Website;
@synthesize LP0;
@synthesize LP08;
@synthesize LP012;
@synthesize LTiur;
@synthesize lsiur;
@synthesize PGiur;
@synthesize RCiur;
@synthesize LP016;
@synthesize GMSCode;
@synthesize LP01;
@synthesize Competitor3;
@synthesize rowguid;
@synthesize OustandingBalance;
@synthesize TCiur;
@synthesize LP09;
@synthesize AgedAmount1;
@synthesize Headoffice;
@synthesize Address1;
@synthesize LP02;
@synthesize MemoIUR;
@synthesize Address2;
@synthesize Name;
@synthesize ImageIUR;
@synthesize Address3;
@synthesize ShortName;
@synthesize Postcode;
@synthesize Address4;
@synthesize LP013;
@synthesize AgedAmount2;
@synthesize Address5;
@synthesize PriceOverride;
@synthesize LP017;
@synthesize LP020;
@synthesize CCiur;
@synthesize LP03;
@synthesize OverrideBonusBlocker;
@synthesize RegisteredAddress1;
@synthesize RegisteredAddress2;
@synthesize PSINumber; 

-(id)initWithManagedLocation:(Location*)loc{
    self=[super init];
    if (self!=nil) {
        self.Active=loc.Active;
        self.Address2=loc.Address2;
        self.Name=loc.Name;
        self.LocationCode=loc.LocationCode;
        self.Email=loc.Email;
        self.Address3=loc.Address3;
        self.LocationIUR=loc.LocationIUR;
        self.MasterLocationIUR=loc.MasterLocationIUR;
        self.Address4=loc.Address4;
        self.Address5=loc.Address5;
        self.SortKey=loc.SortKey;
        self.PhoneNumber=loc.PhoneNumber;
        self.LTiur=loc.LTiur;
        self.Address1=loc.Address1;
        self.Latitude=loc.Latitude;
        self.Longitude=loc.Longitude;
        self.LocationName=Name;
        self.CUiur=loc.CUiur;
        self.CSiur=loc.CSiur;
        self.LTiur=loc.LTiur;
        self.lsiur=loc.lsiur;
        
        self.LocationAddress=@"";
        if (![loc.Address1 isEqualToString:@""]&&loc.Address1!=nil) {
            self.LocationAddress=[self.LocationAddress stringByAppendingFormat:@" %@",loc.Address1];
        }
        if (![loc.Address2 isEqualToString:@""]&&loc.Address2!=nil) {
            self.LocationAddress=[self.LocationAddress stringByAppendingFormat:@" %@",loc.Address2];
        }
        if (![loc.Address3 isEqualToString:@""]&&loc.Address3!=nil) {
            self.LocationAddress=[self.LocationAddress stringByAppendingFormat:@" %@",loc.Address3];
        }
        if (![loc.Address4 isEqualToString:@""]&&loc.Address4!=nil) {
            self.LocationAddress=[self.LocationAddress stringByAppendingFormat:@" %@",loc.Address4];
        }
        if (![loc.Address5 isEqualToString:@""]&&loc.Address5!=nil) {
            self.LocationAddress=[self.LocationAddress stringByAppendingFormat:@" %@",loc.Address5];
        }
        //self.LocationAddress=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",Address1,Address2,Address3,Address4,Address5];
        
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
}
@end
