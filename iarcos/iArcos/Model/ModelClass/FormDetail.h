//
//  FormDetail.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FormDetail : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * ForeColor;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSNumber * SplitList;
@property (nonatomic, retain) NSNumber * FontSize;
@property (nonatomic, retain) NSNumber * ShowSeperators;
@property (nonatomic, retain) NSNumber * AskRepresentative;
@property (nonatomic, retain) NSNumber * DisplayYield;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSString * FormType;
@property (nonatomic, retain) NSString * FontName;
@property (nonatomic, retain) NSNumber * AllowDefaults;
@property (nonatomic, retain) NSNumber * LTlist;
@property (nonatomic, retain) NSDate * DisplayImage;
@property (nonatomic, retain) NSNumber * WholesalerList;
@property (nonatomic, retain) NSNumber * AskOrderType;
@property (nonatomic, retain) NSNumber * ShowExpanded;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * BackColor;
@property (nonatomic, retain) NSString * DividerBackColor;
@property (nonatomic, retain) NSNumber * NumberofSplits;
@property (nonatomic, retain) NSString * DisplayHistoric;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSString * DividerForeColor;
@property (nonatomic, retain) NSDate * DefaultDeliveryDate;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSString * DiscountDeal;
@property (nonatomic, retain) NSString * PrintDeliveryDocket;

@end
