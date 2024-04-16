//
//  CustomerJourneyDetailDateViewController.m
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailDateViewController.h"

@interface CustomerJourneyDetailDateViewController ()

@end

@implementation CustomerJourneyDetailDateViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize templateView = _templateView;
@synthesize myNavigationBar = _myNavigationBar;
@synthesize myPickerView = _myPickerView;
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
@synthesize customerJourneyDetailDateDataManager = _customerJourneyDetailDateDataManager;
@synthesize callGenericServices = _callGenericServices;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.customerJourneyDetailDateDataManager = [[[CustomerJourneyDetailDateDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils maskTemplateViewWithView:self.templateView radius:CGSizeMake(5.0, 5.0)];
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Delete3.png"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithObjects:deleteButton, nil];
    [self.myNavigationBar.topItem setLeftBarButtonItems:leftButtonList];
    [deleteButton release];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.view] autorelease];
    self.callGenericServices.delegate = self;
    self.callGenericServices.isNotRecursion = NO;
}

- (void)deleteButtonPressed:(id)sender {
    void (^deleteActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteJourneyProcessor];
    };
    void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure you want to Remove Entry from Journey Plan" title:@"" target:self lBtnText:@"NO" rBtnText:@"YES" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
}

- (void)deleteJourneyProcessor {
    [self.callGenericServices genericDeleteRecord:@"Journey" iur:[[self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"JourneyIUR"] intValue] action:@selector(backFromDeleteRecordDataResult:) target:self];
}

- (void)backFromDeleteRecordDataResult:(ArcosErrorModel*)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.Code >= 0) {
        [self.callGenericServices.HUD hide:YES];
        [self.customerJourneyDetailDateDataManager removeJourneyWithIUR:[self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"JourneyIUR"]];
        [self.actionDelegate removeButtonPressedFromJourneyDetailDate];
        [self.actionDelegate cancelButtonPressedFromJourneyDetailDate];        
    } else {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showDialogBox:result.Message title:@"" target:self handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark GetDataGenericDelegate
- (UIViewController*)retrieveCallGenericServicesParentViewController {
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myPickerView reloadAllComponents];
    NSNumber* currentWeekNumber = [self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"WeekNumber"];
    NSNumber* currentDayNumber = [self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"DayNumber"];
    NSNumber* currentCallNumber = [self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"CallNumber"];
    int addDays = ([currentWeekNumber intValue] - 1) * 7 + ([currentDayNumber intValue] - 1);
    NSDate* currentJourneyDate = [ArcosUtils addDays:addDays date:self.customerJourneyDetailDateDataManager.journeyStartDate];
    self.myNavigationBar.topItem.title = [ArcosUtils stringFromDate:currentJourneyDate format:@"EEEE dd MMMM yyyy"];
    for (int i = 0; i < [self.customerJourneyDetailDateDataManager.weekNumberDisplayList count]; i++) {
        if ([currentWeekNumber isEqualToNumber:[self.customerJourneyDetailDateDataManager.weekNumberDisplayList objectAtIndex:i]]) {
            [self.myPickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    for (int i = 0; i < [self.customerJourneyDetailDateDataManager.dayNumberDisplayList count]; i++) {
        if ([currentDayNumber isEqualToNumber:[self.customerJourneyDetailDateDataManager.dayNumberDisplayList objectAtIndex:i]]) {
            [self.myPickerView selectRow:i inComponent:1 animated:NO];
            break;
        }
    }
    for (int i = 0; i < [self.customerJourneyDetailDateDataManager.callNumberDisplayList count]; i++) {
        if ([currentCallNumber isEqualToNumber:[self.customerJourneyDetailDateDataManager.callNumberDisplayList objectAtIndex:i]]) {
            [self.myPickerView selectRow:i inComponent:2 animated:NO];
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.callGenericServices.HUD.frame = self.view.bounds;
}

- (void)dealloc {
    self.templateView = nil;
    self.myNavigationBar = nil;
    self.myPickerView = nil;
    self.saveButton = nil;
    self.cancelButton = nil;
    self.customerJourneyDetailDateDataManager = nil;
    self.callGenericServices = nil;
    
    [super dealloc];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.callGenericServices.HUD.frame = self.view.bounds;
    }];
}

- (IBAction)saveButtonPressed:(id)sender {
    self.customerJourneyDetailDateDataManager.rowPointer = 0;
    NSInteger auxWeekNumberRow = [self.myPickerView selectedRowInComponent:0];
    NSInteger auxDayNumberRow = [self.myPickerView selectedRowInComponent:1];
    NSInteger auxCallNumberRow = [self.myPickerView selectedRowInComponent:2];
    self.customerJourneyDetailDateDataManager.currentSelectedWeekNumber = [self.customerJourneyDetailDateDataManager.weekNumberDisplayList objectAtIndex:auxWeekNumberRow];
    self.customerJourneyDetailDateDataManager.currentSelectedDayNumber = [self.customerJourneyDetailDateDataManager.dayNumberDisplayList objectAtIndex:auxDayNumberRow];
    self.customerJourneyDetailDateDataManager.currentSelectedCallNumber = [self.customerJourneyDetailDateDataManager.callNumberDisplayList objectAtIndex:auxCallNumberRow];
    [self.customerJourneyDetailDateDataManager prepareFieldValueListWithWeekNumber:self.customerJourneyDetailDateDataManager.currentSelectedWeekNumber dayNumber:self.customerJourneyDetailDateDataManager.currentSelectedDayNumber callNumber:self.customerJourneyDetailDateDataManager.currentSelectedCallNumber];
    
    [self updateJourneyRecord];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.actionDelegate cancelButtonPressedFromJourneyDetailDate];
}

- (void)updateJourneyRecord {
    if (self.customerJourneyDetailDateDataManager.rowPointer == [self.customerJourneyDetailDateDataManager.fieldNameList count]) return;
    [self.callGenericServices updateRecord:@"Journey" iur:[[self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"JourneyIUR"] intValue] fieldName:[self.customerJourneyDetailDateDataManager.fieldNameList objectAtIndex:self.customerJourneyDetailDateDataManager.rowPointer] newContent:[NSString stringWithFormat:@"%d", [[self.customerJourneyDetailDateDataManager.fieldValueList objectAtIndex:self.customerJourneyDetailDateDataManager.rowPointer] intValue]]];
}

- (void)setUpdateRecordResult:(ArcosGenericReturnObject*)result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.customerJourneyDetailDateDataManager.rowPointer++;
        if (self.customerJourneyDetailDateDataManager.rowPointer == [self.customerJourneyDetailDateDataManager.fieldNameList count]) {
            [self.callGenericServices.HUD hide:YES];
            [self.customerJourneyDetailDateDataManager updateJourneyWithWeekNumber:self.customerJourneyDetailDateDataManager.currentSelectedWeekNumber dayNumber:self.customerJourneyDetailDateDataManager.currentSelectedDayNumber callNumber:self.customerJourneyDetailDateDataManager.currentSelectedCallNumber IUR:[self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"JourneyIUR"]];
            [self.actionDelegate saveButtonPressedFromJourneyDetailDateWithJourneyIUR:[self.customerJourneyDetailDateDataManager.journeyLocationDict objectForKey:@"JourneyIUR"]];
            [self.actionDelegate cancelButtonPressedFromJourneyDetailDate];
        }
        [self updateJourneyRecord];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.customerJourneyDetailDateDataManager.weekNumberDisplayList count];
    }
    if (component == 1) {
        return [self.customerJourneyDetailDateDataManager.dayNumberDisplayList count];
    }
    return [self.customerJourneyDetailDateDataManager.callNumberDisplayList count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32.0;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [self calculateJourneyDateProcessorDidSelectRow:row inComponent:component];
    if (component == 0) {
        return [NSString stringWithFormat:@"%@", [self.customerJourneyDetailDateDataManager.weekNumberDisplayList objectAtIndex:row]];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%@", [self.customerJourneyDetailDateDataManager.dayNumberDisplayList objectAtIndex:row]];
    }
    return [NSString stringWithFormat:@"%@", [self.customerJourneyDetailDateDataManager.callNumberDisplayList objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger weekNumberRow = [self.myPickerView selectedRowInComponent:0];
    NSInteger dayNumberRow = [self.myPickerView selectedRowInComponent:1];
    NSNumber* tmpWeekNumber = [self.customerJourneyDetailDateDataManager.weekNumberDisplayList objectAtIndex:weekNumberRow];
    NSNumber* tmpDayNumber = [self.customerJourneyDetailDateDataManager.dayNumberDisplayList objectAtIndex:dayNumberRow];
    int addDays = ([tmpWeekNumber intValue] - 1) * 7 + ([tmpDayNumber intValue] - 1);
    NSDate* currentJourneyDate = [ArcosUtils addDays:addDays date:self.customerJourneyDetailDateDataManager.journeyStartDate];
    self.myNavigationBar.topItem.title = [ArcosUtils stringFromDate:currentJourneyDate format:@"EEEE dd MMMM yyyy"];
}

- (void)calculateJourneyDateProcessorDidSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 2) return;
    NSInteger weekNumberRow = 0;
    NSInteger dayNumberRow = 0;
    NSNumber* tmpWeekNumber = nil;
    NSNumber* tmpDayNumber = nil;
    NSInteger testWeekRow = 0;
    NSInteger testDayRow = 0;
    if (component == 0) {
        weekNumberRow = row;
        dayNumberRow = [self.myPickerView selectedRowInComponent:1];
        testWeekRow = [self.myPickerView selectedRowInComponent:0];
    }
    if (component == 1) {
        weekNumberRow = [self.myPickerView selectedRowInComponent:0];
        dayNumberRow = row;
        testDayRow = [self.myPickerView selectedRowInComponent:1];
    }
//    NSLog(@"picker row %d %d %d %d", [ArcosUtils convertNSIntegerToInt:component], [ArcosUtils convertNSIntegerToInt:row], [ArcosUtils convertNSIntegerToInt:testWeekRow], [ArcosUtils convertNSIntegerToInt:testDayRow]);
//    NSLog(@"picker %d %d %d", [ArcosUtils convertNSIntegerToInt:component], [ArcosUtils convertNSIntegerToInt:weekNumberRow], [ArcosUtils convertNSIntegerToInt:dayNumberRow]);
    tmpWeekNumber = [self.customerJourneyDetailDateDataManager.weekNumberDisplayList objectAtIndex:weekNumberRow];
    tmpDayNumber = [self.customerJourneyDetailDateDataManager.dayNumberDisplayList objectAtIndex:dayNumberRow];
    int addDays = ([tmpWeekNumber intValue] - 1) * 7 + ([tmpDayNumber intValue] - 1);
    NSDate* currentJourneyDate = [ArcosUtils addDays:addDays date:self.customerJourneyDetailDateDataManager.journeyStartDate];
    self.myNavigationBar.topItem.title = [ArcosUtils stringFromDate:currentJourneyDate format:@"EEEE dd MMMM yyyy"];
}

@end
