//
//  OrderPadFooterViewDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 02/09/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "OrderPadFooterViewDataManager.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"

@implementation OrderPadFooterViewDataManager


- (void)dealloc {
    
    [super dealloc];
}


- (OrderPadFooterViewCell*)generateTableFooterView {
    OrderPadFooterViewCell* resultView = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"OrderPadFooterViewCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[OrderPadFooterViewCell class]] && [(OrderPadFooterViewCell*)nibItem tag] == 1) {
            resultView = (OrderPadFooterViewCell*)nibItem;
            break;
        }
    }
    return resultView;
}

- (void)configDataWithTableFooterView:(OrderPadFooterViewCell*)anOrderPadFooterViewCell {
    NSMutableArray* sortedOrderKeyList = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allValues]];
    float totalBonus = 0.0;
    float totalTrade = 0.0;
    float totalVAT = 0.0;
    BOOL percentageSetFlag = NO;
    
//    NSMutableDictionary* descrDetailDictHashMap = nil;
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
//        NSMutableDictionary* VCIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[sortedOrderKeyList count]];
//        for (int i = 0; i < [sortedOrderKeyList count]; i++) {
//            NSString* tmpOrderKey = [sortedOrderKeyList objectAtIndex:i];
//            NSMutableDictionary* tmpOrderLineDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:tmpOrderKey];
//            NSNumber* tmpVCIUR = [tmpOrderLineDict objectForKey:@"VCIUR"];
//            [VCIURHashMap setObject:tmpVCIUR forKey:tmpVCIUR];
//        }
//        NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:[NSMutableArray arrayWithArray:[VCIURHashMap allKeys]]];
//        descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
//        for (int i = 0; i < [descrDetailDictList count]; i++) {
//            NSDictionary* tmpDescrDetailDict = [descrDetailDictList objectAtIndex:i];
//            [descrDetailDictHashMap setObject:tmpDescrDetailDict forKey:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
//        }
//    }
    
    for (int i = 0; i < [sortedOrderKeyList count]; i++) {
        NSString* tmpOrderKey = [sortedOrderKeyList objectAtIndex:i];
        NSMutableDictionary* tmpOrderLineDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:tmpOrderKey];
        totalTrade += [[tmpOrderLineDict objectForKey:@"LineValue"] floatValue];
        totalBonus += [[tmpOrderLineDict objectForKey:@"Bonus"] intValue] * [[tmpOrderLineDict objectForKey:@"UnitPrice"] floatValue];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
//            NSNumber* tmpVCIUR = [tmpOrderLineDict objectForKey:@"VCIUR"];
//            NSDictionary* tmpDescrDetailDict = [descrDetailDictHashMap objectForKey:tmpVCIUR];
//            if (tmpDescrDetailDict != nil) {
//                totalVAT += [[tmpOrderLineDict objectForKey:@"LineValue"] floatValue] / 100 * [[tmpDescrDetailDict objectForKey:@"Dec1"] floatValue];
//            }
            totalVAT += [[tmpOrderLineDict objectForKey:@"vatAmount"] floatValue];
        }
    }
    int percentageValue = 0;
    if (totalBonus > 0.0) {
        anOrderPadFooterViewCell.totalBonusValue.text = [NSString stringWithFormat:@"Total Bonus Value %.2f", totalBonus];
        if (totalTrade > 0.0) {            
            percentageValue = (int)(totalBonus / totalTrade * 100);
            if (percentageValue > 0) {
                percentageSetFlag = YES;
                anOrderPadFooterViewCell.totalBonusValue.text = [NSString stringWithFormat:@"Total Bonus Value %.2f : %d%%", totalBonus, percentageValue];
            }
        }
        if (percentageSetFlag) {
            NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
            NSNumber* BonusBlockedat = [configDict objectForKey:@"BonusBlockedat"];
            if (percentageValue > [BonusBlockedat intValue]) {
                anOrderPadFooterViewCell.totalBonusValue.textColor = [UIColor yellowColor];
            } else {
                anOrderPadFooterViewCell.totalBonusValue.textColor = [UIColor whiteColor];
            }
        } else {
            anOrderPadFooterViewCell.totalBonusValue.textColor = [UIColor whiteColor];
        }
    } else {
        anOrderPadFooterViewCell.totalBonusValue.text = @"";
    }
        
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        anOrderPadFooterViewCell.totalTradeValue.text = [NSString stringWithFormat:@"Total Trade %.2f", totalTrade];
    } else {
        anOrderPadFooterViewCell.totalTradeValue.text = [NSString stringWithFormat:@"Goods: %.2f VAT: %.2f Total: %.2f", totalTrade, totalVAT, (totalTrade + totalVAT)];
    }
}

@end
