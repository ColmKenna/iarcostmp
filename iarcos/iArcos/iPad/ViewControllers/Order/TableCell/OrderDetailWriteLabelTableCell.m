//
//  OrderDetailWriteLabelTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailWriteLabelTableCell.h"

@implementation OrderDetailWriteLabelTableCell
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize isEventSet = _isEventSet;
@synthesize checkoutDataManager = _checkoutDataManager;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.globalWidgetViewController = nil;
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    self.checkoutDataManager = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    NSMutableDictionary* tmpDataDict = [theData objectForKey:@"FieldData"];
    self.fieldValueLabel.text = [tmpDataDict objectForKey:@"Title"];
    if (self.isNotEditable) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag] && ([[self.cellData objectForKey:@"CellKey"] isEqualToString:@"wholesaler"] || [[self.cellData objectForKey:@"CellKey"] isEqualToString:@"acctNo"])) {
            self.fieldValueLabel.textColor = [UIColor blackColor];
        }
    }
    if (!self.isEventSet) {
        self.isEventSet = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.fieldValueLabel addGestureRecognizer:singleTap];
        [singleTap release];
    }
}

-(void)handleSingleTapGesture:(id)sender {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag] && ([[self.cellData objectForKey:@"CellKey"] isEqualToString:@"wholesaler"] || [[self.cellData objectForKey:@"CellKey"] isEqualToString:@"acctNo"])) return;
    if (self.isNotEditable) return;
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    BOOL isContactTaped = NO;
    NSString* cellKey = [self.cellData objectForKey:@"CellKey"];
    NSMutableDictionary* auxOrderHeader = [self.delegate retrieveParentOrderHeader];
    NSDictionary* auxLocationDict = [auxOrderHeader objectForKey:@"Customer"];
    if ([cellKey isEqualToString:@"contact"]) {
        isContactTaped = YES;
        NSMutableArray* dataList = nil;
        NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[auxLocationDict objectForKey:@"LocationIUR"]];
        if ([objectList count] > 0) {
            dataList = objectList;            
        }
        self.globalWidgetViewController = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:dataList title:@"Contact"];
    } else if (sender == nil && [cellKey isEqualToString:@"status"]) {
        NSNumber* orderSendStatus = [SettingManager defaultOrderSentStatus];
        self.globalWidgetViewController = [self.widgetFactory CreateGenericCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus pickerDefaultValue:orderSendStatus];
        PickerWidgetViewController* pwvc = (PickerWidgetViewController*)self.globalWidgetViewController;
        for (int i = 0; i < [pwvc.pickerData count]; i++) {
            NSMutableDictionary* aDict = [pwvc.pickerData objectAtIndex:i];
            if ([[aDict objectForKey:@"DescrDetailIUR"] isEqualToNumber:orderSendStatus]) {
                [pwvc.picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    } else if([cellKey isEqualToString:@"acctNo"]) {
        if (self.checkoutDataManager == nil) {
            self.checkoutDataManager = [[[CheckoutDataManager alloc] init] autorelease];
        }
        NSNumber* locationIUR = [auxLocationDict objectForKey:@"LocationIUR"];
        NSDictionary* wholesalerDict = [auxOrderHeader objectForKey:@"wholesaler"];
        NSNumber* fromLocationIUR = [ArcosUtils convertNilToZero:[wholesalerDict objectForKey:@"LocationIUR"]];
        NSMutableArray* accountNoList = [self.checkoutDataManager getAccountNoList:locationIUR fromLocationIUR:fromLocationIUR];
        NSMutableDictionary* miscDataDict = [self.checkoutDataManager getAcctNoMiscDataDict:locationIUR fromLocationIUR:fromLocationIUR];

        self.globalWidgetViewController=[self.widgetFactory CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:accountNoList miscDataDict:miscDataDict];
    } else {
        NSNumber* writeType = [self.cellData objectForKey:@"WriteType"];
        self.globalWidgetViewController = [self.widgetFactory CreateCategoryWidgetWithDataSource:[writeType intValue]];
    }
    
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    if (self.globalWidgetViewController != nil) {
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.fieldValueLabel;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.fieldValueLabel.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
    if (self.globalWidgetViewController == nil) {
        self.fieldValueLabel.text = [GlobalSharedClass shared].unassignedText;
    }
}

-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

-(BOOL)allowToShowAddContactButton {
    return NO;
}
-(BOOL)allowToShowAddAccountNoButton {
    return NO;
}

@end
