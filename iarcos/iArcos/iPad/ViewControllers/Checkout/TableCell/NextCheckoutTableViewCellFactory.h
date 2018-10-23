//
//  NextCheckoutTableViewCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NextCheckoutBaseTableViewCell.h"

@interface NextCheckoutTableViewCellFactory : NSObject {
    NSString* _dateLabelTableCellId;
    NSString* _readOnlyLabelTableCellId;
    NSString* _writableLabelTableCellId;
    NSString* _contactLabelTableCellId;
    NSString* _accountLabelTableCellId;
    NSString* _employeeLabelTableCellId;
    NSString* _textFieldTableCellId;
    NSString* _textViewTableCellId;
    NSString* _followUpTextViewTableCellId;
    NSString* _followUpEmployeeTableCellId;
    NSString* _followUpWritableLabelTableCellId;
    NSString* _followUpDateLabelTableCellId;
    NSString* _deliveryInstructions1TableCellId;
}

@property(nonatomic, retain) NSString* dateLabelTableCellId;
@property(nonatomic, retain) NSString* readOnlyLabelTableCellId;
@property(nonatomic, retain) NSString* writableLabelTableCellId;
@property(nonatomic, retain) NSString* contactLabelTableCellId;
@property(nonatomic, retain) NSString* accountLabelTableCellId;
@property(nonatomic, retain) NSString* employeeLabelTableCellId;
@property(nonatomic, retain) NSString* textFieldTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* followUpTextViewTableCellId;
@property(nonatomic, retain) NSString* followUpEmployeeTableCellId;
@property(nonatomic, retain) NSString* followUpWritableLabelTableCellId;
@property(nonatomic, retain) NSString* followUpDateLabelTableCellId;
@property(nonatomic, retain) NSString* deliveryInstructions1TableCellId;

+ (id)factory;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (NextCheckoutBaseTableViewCell*)createNextCheckoutBaseTableViewCellWithData:(NSMutableDictionary*)aData;

@end
