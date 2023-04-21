//
//  OrderSender.m
//  Arcos
//
//  Created by David Kilmartin on 01/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderSender.h"
#import "ArcosService.h"
#import "ArcosCoreData.h"
#import "SettingManager.h"

@interface OrderSender (Private)
-(ArcosOrderTransferObject*)orderTransferOBWithOrderNumber:(NSNumber*)orderNumber;
@end

@implementation OrderSender
@synthesize delegate;
@synthesize theOrderNumber;

+(id)sender{
    return [[[self alloc]init]autorelease];
}

-(void)dealloc {
    self.theOrderNumber = nil;
    
    [super dealloc];
}

-(void)sendWithOrderNumber:(NSNumber*)orderNumber{
    self.theOrderNumber=orderNumber;
    
    ArcosService* service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    service.logging=YES;
    
    ArcosOrderTransferObject* AOTO=[self orderTransferOBWithOrderNumber:orderNumber];
    
    [service Saveorderheader:self action:@selector(resultBackFromService:) CompanyIUR:[[SettingManager companyIUR]intValue] OrderTransfer:AOTO];
    
}
-(void)send{
    
    if (self.theOrderNumber==nil) {
        return;
    }
    
    ArcosService* service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    
    ArcosOrderTransferObject* AOTO=[self orderTransferOBWithOrderNumber:self.theOrderNumber];
    
    [service Saveorderheader:self action:@selector(resultBackFromService:) CompanyIUR:[[SettingManager companyIUR]intValue] OrderTransfer:AOTO];
}
//service call back
-(void)resultBackFromService:(id)result{
    if (result!=nil) {
        if ([result isKindOfClass:[NSError class]]) {          
            
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from sending service %@",[anError description]);
            //handle the error 1003
            if ([anError code]==1003) {
                [[ArcosCoreData sharedArcosCoreData]changeOrderHeaderIurWithOrderNumber:theOrderNumber WithValue:[NSNumber numberWithInt:-1]];
                [self.delegate Error1003:anError forOrderNumber:self.theOrderNumber];
            }else{
                [self.delegate sendingStatus:NO withReason:[anError description] forOrderNumber:self.theOrderNumber withNewOrderNumber:nil];
            }
        }else if ([result isKindOfClass:[SoapFault class]]) {
            SoapFault* fault=(SoapFault*)result;
            [self.delegate sendingStatus:NO withReason:fault.description forOrderNumber:self.theOrderNumber withNewOrderNumber:nil];
        }else{
//            NSLog(@"the sending order result back is ---- %@",result);
            ArcosOrderHeaderBO* orderHeader=(ArcosOrderHeaderBO*)result;
            
            BOOL isSuccess=[[ArcosCoreData sharedArcosCoreData]saveSentOrderWithOrderHeaderBO:orderHeader];
            
            [self.delegate sendingStatus:isSuccess withReason:[NSString stringWithFormat:@"%@",orderHeader.DeliveryInstructions1] forOrderNumber:self.theOrderNumber withNewOrderNumber:[NSNumber numberWithInt:orderHeader.OrderNumber]];
            
        }
        
    }else{//result is nil
        [self.delegate ServerFaultWithOrderNumber:self.theOrderNumber];
    }
    
}

-(ArcosOrderTransferObject*)orderTransferOBWithOrderNumber:(NSNumber*)orderNumber{
    OrderHeader* OH=[[ArcosCoreData sharedArcosCoreData]orderHeaderWithOrderNumber:orderNumber];
    if (OH==nil) {
        return nil;
    }
    
    //fill the order transfer object
    ArcosOrderTransferObject* AOTO=[[[ArcosOrderTransferObject alloc]init]autorelease];
    

    //fill the order header
    ArcosOrderHeaderBO* AOHB=[[[ArcosOrderHeaderBO alloc]init]autorelease];

    NSMutableArray* location=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:OH.LocationIUR];
    NSNumber* lat=[[location objectAtIndex:0]objectForKey:@"Latitude"];
    NSNumber* lon=[[location objectAtIndex:0]objectForKey:@"Longitude"];
    AOHB.Latitude=[NSDecimalNumber decimalNumberWithString:[lat stringValue]];
    AOHB.Longitude=[NSDecimalNumber decimalNumberWithString:[lon stringValue]];

                   
    AOHB.IUR=[OH.IUR intValue];
    AOHB.OrderNumber=[OH.OrderNumber intValue];
    AOHB.CallIUR=[OH.CallIUR intValue];
    AOHB.OTIUR=[OH.OTiur intValue];
    AOHB.PromotionIUR=[OH.PromotionIUR intValue];
    AOHB.DocketIUR=[OH.DocketIUR intValue];
    AOHB.CustomerRef=OH.CustomerRef;
    AOHB.OrderDate=OH.OrderDate;
    AOHB.EnteredDate=OH.EnteredDate;
    AOHB.CallDuration=[OH.CallDuration intValue];
    AOHB.DeliveryDate=OH.DeliveryDate;
    AOHB.DeliveryInstructions1=OH.DeliveryInstructions1;
    AOHB.DeliveryInstructions2=OH.DeliveryInstructions2;
    AOHB.OSIUR=[OH.OSiur intValue];
    AOHB.LocationIUR=[OH.LocationIUR intValue];
    AOHB.ContactIUR=[OH.ContactIUR intValue];
    AOHB.LocationCode=OH.LocationCode;
    AOHB.MemoIUR=[OH.MemoIUR intValue];
    AOHB.FormIUR=[OH.FormIUR intValue];
    AOHB.EmployeeIUR=[OH.EmployeeIUR intValue];
    AOHB.WholesaleIUR=[OH.WholesaleIUR intValue];
    AOHB.TotalGoods=OH.TotalGoods;
    AOHB.TotalVAT=OH.TotalVat;
    AOHB.TotalQTY=[OH.TotalQty intValue];
    AOHB.TotalBonus=[OH.TotalBonus intValue];
    AOHB.ExchangeRate=OH.ExchangeRate;
    AOHB.TotalBonusValue=OH.TotalBonusValue;
    AOHB.TotalFOC=[OH.TotalFOC intValue];
    AOHB.TotalTesters=[OH.TotalTesters intValue];
    AOHB.CallCost=OH.CallCost;
    AOHB.DSIUR=[OH.DSiur intValue];
    AOHB.InvoiceRef=OH.InvoiseRef;
    AOHB.PostedIUR=[OH.PosteedIUR intValue];
    AOHB.Points=[OH.Points intValue];
    AOHB.TotalNetRevenue=OH.TotalNetRevenue;
    AOHB.Longitude=[NSDecimalNumber decimalNumberWithString:[OH.Longitude stringValue]];
    AOHB.Latitude=[NSDecimalNumber decimalNumberWithString:[OH.Latitude stringValue]];

    
    //fill the order line
    NSSet* orderLines=OH.orderlines;
    NSArray* sortedOrderLines = nil;
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"OrderLine" ascending:YES] autorelease];
    sortedOrderLines = [orderLines sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    NSMutableArray* orderLinesArray=[NSMutableArray array];
    
    for (OrderLine* OL in sortedOrderLines) {
        ArcosOrderLineBO* AOLB=[[[ArcosOrderLineBO alloc]init]autorelease];
        //AOLB.IUR=OL.IUR;
        AOLB.OrderNumber=[OL.OrderNumber intValue];
        AOLB.OrderLine=[OL.OrderLine intValue];
        AOLB.OrderHeaderIUR=[OL.OrderHeaderIUR intValue];
        AOLB.LocationIUR=[OL.LocationIUR intValue];
        AOLB.OrderDate=OL.OrderDate;
        AOLB.ProductIUR=[OL.ProductIUR intValue];
        AOLB.ProductCode=OL.ProductCode;
        AOLB.Qty=[OL.Qty intValue];
        AOLB.Bonus=[OL.Bonus intValue];
        AOLB.QtyReturned=[OL.QtyReturned intValue];
        AOLB.RRIUR=[OL.PPIUR intValue];
        AOLB.InStock=[OL.InStock intValue];
        AOLB.Testers=[OL.Testers intValue];
        //AOLB.Comments=OL.comments;
        AOLB.LineValue=OL.LineValue;
        AOLB.VatAmount=OL.vatAmount;
        AOLB.UnitPrice=OL.UnitPrice;
        AOLB.CostPrice=OL.CostPrice;
        AOLB.InvoiceRef=OL.InvoiceRef;
        AOLB.InvoiceLineNumber=[OL.InvoiceLineNumber intValue];
        AOLB.FOC=[OL.FOC intValue];
        //AOLB.BatchRef=OL.batchref;
        AOLB.CallCost=[NSDecimalNumber decimalNumberWithString:[OL.CallCost stringValue]];
        //AOLB.SageComments1=OL.segecomments1;
        //AOLB.SageComments2=OL.sagecomment2;
        AOLB.DiscountPercent=OL.DiscountPercent;
        [orderLinesArray addObject:AOLB];
    }
    AOHB.Lines=orderLinesArray;
    
    //fill the memo and call
    if(OH.call!=nil){
        AOTO.CtIUR=[OH.call.CTiur intValue];
    }else{
        AOTO.CtIUR=0;
    }
    if (OH.memo!=nil) {
        AOTO.MemoDetails=OH.memo.Details;
        if ([OH.NumberOflines intValue] == 0) {
            AOTO.MemoDetails = [ArcosUtils wrapStringByCDATA:OH.memo.Details];
        }
    }else{
        AOTO.MemoDetails=@"";
    }
    
    AOTO.Order=AOHB;
    
    //fill the call trans
    NSSet* calltrans=OH.calltrans;
    NSMutableArray* calltransArray=[NSMutableArray array];
    if (calltrans!=nil) {
        for (CallTran* CT in calltrans) {
            ArcosCallTran* ACT=[[[ArcosCallTran alloc]init]autorelease];
            ACT.CallIUR=[CT.CAllIUR intValue];
            ACT.DetailIUR=[CT.DetailIUR intValue];
            ACT.DetailLevel=CT.DetailLevelIUR;
            ACT.ProductIUR=[CT.ProductIUR intValue];
            ACT.EmployeeIUR=[CT.EmployeeIUR intValue];
            ACT.DTIUR=[CT.DTiur intValue];
            ACT.FullFilled=[CT.Fullfilled boolValue];
            ACT.CallDate=CT.Calldate;
            ACT.Score=[CT.Score intValue];
            ACT.Reference=CT.Reference;
            [calltransArray addObject:ACT];
            ACT.EmployeeIUR=AOHB.EmployeeIUR;
        }
        AOTO.CallTrans=calltransArray;
        

    }
    
//    NSLog(@"the order header object will be sent to server is %@",AOTO);
    return AOTO;
}
@end
