//
//  FormRowsFooterMatTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsFooterMatTableViewCell.h"

@implementation FormRowsFooterMatTableViewCell
@synthesize titleLabel = _titleLabel;
@synthesize templateView = _templateView;
@synthesize separatorLabel = _separatorLabel;
@synthesize qtyLabel0 = _qtyLabel0;
@synthesize qtyLabel1 = _qtyLabel1;
@synthesize qtyLabel2 = _qtyLabel2;
@synthesize qtyLabel3 = _qtyLabel3;
@synthesize qtyLabel4 = _qtyLabel4;
@synthesize qtyLabel5 = _qtyLabel5;
@synthesize qtyLabel6 = _qtyLabel6;
@synthesize qtyLabel7 = _qtyLabel7;
@synthesize qtyLabel8 = _qtyLabel8;
@synthesize qtyLabel9 = _qtyLabel9;
@synthesize qtyLabel10 = _qtyLabel10;
@synthesize qtyLabel11 = _qtyLabel11;

@synthesize bonLabel0 = _bonLabel0;
@synthesize bonLabel1 = _bonLabel1;
@synthesize bonLabel2 = _bonLabel2;
@synthesize bonLabel3 = _bonLabel3;
@synthesize bonLabel4 = _bonLabel4;
@synthesize bonLabel5 = _bonLabel5;
@synthesize bonLabel6 = _bonLabel6;
@synthesize bonLabel7 = _bonLabel7;
@synthesize bonLabel8 = _bonLabel8;
@synthesize bonLabel9 = _bonLabel9;
@synthesize bonLabel10 = _bonLabel10;
@synthesize bonLabel11 = _bonLabel11;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.titleLabel = nil;
    self.templateView = nil;
    self.separatorLabel = nil;
    self.qtyLabel0 = nil;
    self.qtyLabel1 = nil;
    self.qtyLabel2 = nil;
    self.qtyLabel3 = nil;
    self.qtyLabel4 = nil;
    self.qtyLabel5 = nil;
    self.qtyLabel6 = nil;
    self.qtyLabel7 = nil;
    self.qtyLabel8 = nil;
    self.qtyLabel9 = nil;
    self.qtyLabel10 = nil;
    self.qtyLabel11 = nil;
    
    self.bonLabel0 = nil;
    self.bonLabel1 = nil;
    self.bonLabel2 = nil;
    self.bonLabel3 = nil;
    self.bonLabel4 = nil;
    self.bonLabel5 = nil;
    self.bonLabel6 = nil;
    self.bonLabel7 = nil;
    self.bonLabel8 = nil;
    self.bonLabel9 = nil;
    self.bonLabel10 = nil;
    self.bonLabel11 = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict matDataFoundFlag:(BOOL)aMatDataFoundFlag {
    self.titleLabel.text = [aDataDict objectForKey:@"Details"];
//    NSLog(@"title: %@", [aDataDict objectForKey:@"Details"]);
    if (aMatDataFoundFlag) {
        NSDictionary* mainDataDict = [aDataDict objectForKey:@"Data"];
        int monthStep = 2;
        if ([[aDataDict objectForKey:@"Details"] isEqualToString:@"TY"]) {
            monthStep = 14;
        }
        for (int i = 0; i < 12; i++) {
            NSString* qtyMethodNameString = [NSString stringWithFormat:@"qtyLabel%d", i];
            SEL qtyMethodSelector = NSSelectorFromString(qtyMethodNameString);
            NSString* valueNameString = [NSString stringWithFormat:@"setText:"];
            SEL valueSelector = NSSelectorFromString(valueNameString);
            
            int currentMonth = i + monthStep;
            NSString* qtyKey = @"";
            NSString* bonKey = @"";
            if (currentMonth < 10) {
                qtyKey  = [NSString stringWithFormat:@"qty0%d", currentMonth];
                bonKey = [NSString stringWithFormat:@"bonus0%d", currentMonth];
            } else {
                qtyKey = [NSString stringWithFormat:@"qty%d", currentMonth];
                bonKey = [NSString stringWithFormat:@"bonus%d", currentMonth];
            }
            [[self performSelector:qtyMethodSelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[[mainDataDict objectForKey:qtyKey] stringValue]]];
//            NSLog(@"qty %@ -- %@", qtyKey, [[mainDataDict objectForKey:qtyKey] stringValue]);
            
            NSString* bonMethodNameString = [NSString stringWithFormat:@"bonLabel%d", i];
            SEL bonMethodSelector = NSSelectorFromString(bonMethodNameString);
            [[self performSelector:bonMethodSelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[[mainDataDict objectForKey:bonKey] stringValue]]];
        }
    } else {
        for (int i = 0; i < 12; i++) {
            NSString* qtyMethodNameString = [NSString stringWithFormat:@"qtyLabel%d", i];
            SEL qtyMethodSelector = NSSelectorFromString(qtyMethodNameString);
            NSString* valueNameString = [NSString stringWithFormat:@"setText:"];
            SEL valueSelector = NSSelectorFromString(valueNameString);
            [[self performSelector:qtyMethodSelector] performSelector:valueSelector withObject:@""];
            
            NSString* bonMethodNameString = [NSString stringWithFormat:@"bonLabel%d", i];
            SEL bonMethodSelector = NSSelectorFromString(bonMethodNameString);
            [[self performSelector:bonMethodSelector] performSelector:valueSelector withObject:@""];
        }
    }
}

@end
