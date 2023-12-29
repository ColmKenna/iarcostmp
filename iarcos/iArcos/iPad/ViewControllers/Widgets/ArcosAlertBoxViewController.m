//
//  ArcosAlertBoxViewController.m
//  iArcos
//
//  Created by Richard on 12/12/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosAlertBoxViewController.h"
#import "ArcosCoreData.h"

@interface ArcosAlertBoxViewController ()

@end

@implementation ArcosAlertBoxViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize templateView = _templateView;
@synthesize myNavigationBar = _myNavigationBar;
@synthesize qtyDesc = _qtyDesc;
@synthesize qtyValue = _qtyValue;
@synthesize bonusDesc = _bonusDesc;
@synthesize bonusValue = _bonusValue;
@synthesize qtySplitDesc = _qtySplitDesc;
@synthesize qtySplitValue = _qtySplitValue;
@synthesize bonusSplitDesc = _bonusSplitDesc;
@synthesize bonusSplitValue = _bonusSplitValue;
@synthesize discDesc = _discDesc;
@synthesize discValue = _discValue;
@synthesize totalDesc = _totalDesc;
@synthesize totalValue = _totalValue;
@synthesize msgValue = _msgValue;
@synthesize amendButton = _amendButton;
@synthesize saveButton = _saveButton;
@synthesize disableSaveButtonFlag = _disableSaveButtonFlag;
@synthesize checkWholesalerFlag = _checkWholesalerFlag;
@synthesize messageContent = _messageContent;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.disableSaveButtonFlag = NO;
        self.checkWholesalerFlag = NO;
        self.messageContent = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myNavigationBar.topItem.title = [NSString stringWithFormat:@"%@",[ArcosUtils convertNilToEmpty:[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"wholesalerText"]]];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.templateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.templateView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.templateView.layer.mask = maskLayer;
    [maskLayer release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    int totalInStock = 0;
    int totalFOC = 0;
    for(NSString* aKey in [OrderSharedClass sharedOrderSharedClass].currentOrderCart) {
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:aKey];
        NSNumber* isSelected = [aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            totalInStock += [[aDict objectForKey:@"InStock"] intValue];
            totalFOC += [[aDict objectForKey:@"FOC"] intValue];
        }
    }
    int totalQty = [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalQty"] intValue];
    int totalBonus = [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalBonus"] intValue];
    self.qtyValue.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalQty]];
    self.bonusValue.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalBonus]];
    self.qtySplitValue.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalInStock]];
    self.bonusSplitValue.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalFOC]];
    self.discValue.text = @"";
    self.totalValue.text = [NSString stringWithFormat:@"%@",[ArcosUtils convertNilToEmpty:[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"totalGoodsText"]]];
    if (totalInStock == 0) {
        self.qtySplitDesc.hidden = YES;
        self.qtySplitValue.hidden = YES;
    }
    if (totalFOC == 0) {
        self.bonusSplitDesc.hidden = YES;
        self.bonusSplitValue.hidden = YES;
    }
    if (totalInStock != 0 || totalFOC != 0) {
        self.qtyDesc.text = @"Cases";
    } else {
        self.qtyDesc.text = @"Quantity";
    }
    if (self.checkWholesalerFlag) {
        if (totalInStock > 0 || totalFOC > 0) {
            NSNumber* wholesalerIUR = [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"wholesaler"] objectForKey:@"LocationIUR"];
            NSMutableArray* fromLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:wholesalerIUR];
            NSString* address2 = @"";
            if ([fromLocationList count] > 0) {
                NSDictionary* fromLocationDict = [fromLocationList objectAtIndex:0];
                address2 = [[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[fromLocationDict objectForKey:@"Address2"]]] lowercaseString];
            }
            if ([address2 containsString:@"unit"]) {
                self.msgValue.text = @"Units not allowed for this wholesaler – please amend";
                self.saveButton.enabled = NO;
            }
        }
    }
    
    if (self.messageContent != nil && ![self.messageContent isEqualToString:@""]) {
        self.msgValue.text = self.messageContent;        
    }
    if (self.disableSaveButtonFlag) {
        self.saveButton.enabled = NO;
    }
}

- (void)dealloc {
    self.templateView = nil;
    self.myNavigationBar = nil;
    self.qtyDesc = nil;
    self.qtyValue = nil;
    self.bonusDesc = nil;
    self.bonusValue = nil;
    self.qtySplitDesc = nil;
    self.qtySplitValue = nil;
    self.bonusSplitDesc = nil;
    self.bonusSplitValue = nil;
    self.discDesc = nil;
    self.discValue = nil;
    self.totalDesc = nil;
    self.totalValue = nil;
    self.msgValue = nil;
    self.amendButton = nil;
    self.saveButton = nil;
    self.messageContent = nil;
    
    [super dealloc];
}

- (IBAction)didAmendButtonPressed:(id)sender {
    [self.actionDelegate amendButtonPressed:self];
}

- (IBAction)didSaveButtonPressed:(id)sender {
    [self.actionDelegate saveButtonPressed:self];
}

@end
