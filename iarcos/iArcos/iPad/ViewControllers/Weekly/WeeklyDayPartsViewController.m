//
//  WeeklyDayPartsViewController.m
//  iArcos
//
//  Created by David Kilmartin on 21/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "WeeklyDayPartsViewController.h"

@interface WeeklyDayPartsViewController ()

@end

@implementation WeeklyDayPartsViewController
@synthesize weeklyMainTemplateDataManager = _weeklyMainTemplateDataManager;
@synthesize headingDesc = _headingDesc;
@synthesize headingTemplateAM = _headingTemplateAM;
@synthesize headingChildTemplateAM = _headingChildTemplateAM;
@synthesize headingButtonAM = _headingButtonAM;
@synthesize headingAM = _headingAM;
@synthesize headingSpace = _headingSpace;
@synthesize headingTemplatePM = _headingTemplatePM;
@synthesize headingChildTemplatePM = _headingChildTemplatePM;
@synthesize headingButtonPM = _headingButtonPM;
@synthesize headingPM = _headingPM;
@synthesize headingView = _headingView;

@synthesize weekdayTemplateView = _weekdayTemplateView;

@synthesize mondayDesc = _mondayDesc;
@synthesize mondayAM = _mondayAM;
@synthesize mondaySpace = _mondaySpace;
@synthesize mondayPM = _mondayPM;
@synthesize mondayView = _mondayView;
@synthesize mondayTemplateView = _mondayTemplateView;

@synthesize tuesdayDesc = _tuesdayDesc;
@synthesize tuesdayAM = _tuesdayAM;
@synthesize tuesdaySpace = _tuesdaySpace;
@synthesize tuesdayPM = _tuesdayPM;
@synthesize tuesdayView = _tuesdayView;
@synthesize tuesdayTemplateView = _tuesdayTemplateView;

@synthesize wednesdayDesc = _wednesdayDesc;
@synthesize wednesdayAM = _wednesdayAM;
@synthesize wednesdaySpace = _wednesdaySpace;
@synthesize wednesdayPM = _wednesdayPM;
@synthesize wednesdayView = _wednesdayView;
@synthesize wednesdayTemplateView = _wednesdayTemplateView;

@synthesize thursdayDesc = _thursdayDesc;
@synthesize thursdayAM = _thursdayAM;
@synthesize thursdaySpace = _thursdaySpace;
@synthesize thursdayPM = _thursdayPM;
@synthesize thursdayView = _thursdayView;
@synthesize thursdayTemplateView = _thursdayTemplateView;

@synthesize fridayDesc = _fridayDesc;
@synthesize fridayAM = _fridayAM;
@synthesize fridaySpace = _fridaySpace;
@synthesize fridayPM = _fridayPM;
@synthesize fridayView = _fridayView;
@synthesize fridayTemplateView = _fridayTemplateView;

@synthesize saturdayDesc = _saturdayDesc;
@synthesize saturdayAM = _saturdayAM;
@synthesize saturdaySpace = _saturdaySpace;
@synthesize saturdayPM = _saturdayPM;
@synthesize saturdayView = _saturdayView;
@synthesize saturdayTemplateView = _saturdayTemplateView;

@synthesize sundayDesc = _sundayDesc;
@synthesize sundayAM = _sundayAM;
@synthesize sundaySpace = _sundaySpace;
@synthesize sundayPM = _sundayPM;
@synthesize sundayView = _sundayView;
@synthesize sundayTemplateView = _sundayTemplateView;

@synthesize footerThisWeekHeading = _footerThisWeekHeading;
@synthesize footerHeadingSpace = _footerHeadingSpace;
@synthesize footerMonthToDateHeading = _footerMonthToDateHeading;
@synthesize footerOnTerritoryDesc = _footerOnTerritoryDesc;
@synthesize footerOnTerritoryThisWeekFigure = _footerOnTerritoryThisWeekFigure;
@synthesize footerOnTerritorySpace = _footerOnTerritorySpace;
@synthesize footerOnTerritoryMonthToDateFigure = _footerOnTerritoryMonthToDateFigure;
@synthesize footerOffTerritoryDesc = _footerOffTerritoryDesc;
@synthesize footerOffTerritoryThisWeekFigure = _footerOffTerritoryThisWeekFigure;
@synthesize footerOffTerritorySpace = _footerOffTerritorySpace;
@synthesize footerOffTerritoryMonthToDateFigure = _footerOffTerritoryMonthToDateFigure;

@synthesize footerView = _footerView; 

@synthesize currentLabel = _currentLabel;
@synthesize labelList = _labelList;
@synthesize viewList = _viewList;
@synthesize weeklyDayPartsDataManager = _weeklyDayPartsDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.weeklyDayPartsDataManager = [[[WeeklyDayPartsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewList = [NSMutableArray arrayWithObjects:self.mondayView, self.tuesdayView, self.wednesdayView, self.thursdayView, self.fridayView, self.saturdayView, self.sundayView, nil];
    for (int i = 0; i < [self.viewList count]; i++) {
        UIView* auxView = [self.viewList objectAtIndex:i];
        [auxView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [auxView.layer setBorderWidth:0.5];
        [auxView.layer setCornerRadius:3.0f];
    }
    self.footerThisWeekHeading.textColor = [UIColor grayColor];
    self.footerMonthToDateHeading.textColor = [UIColor grayColor];
    
    
    UITapGestureRecognizer* singleTap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.mondayAM addGestureRecognizer:singleTap10];
    [singleTap10 release];
    UITapGestureRecognizer* singleTap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.mondayPM addGestureRecognizer:singleTap11];
    [singleTap11 release];
    
    UITapGestureRecognizer* singleTap20 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.tuesdayAM addGestureRecognizer:singleTap20];
    [singleTap20 release];
    UITapGestureRecognizer* singleTap21 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.tuesdayPM addGestureRecognizer:singleTap21];
    [singleTap21 release];
    
    UITapGestureRecognizer* singleTap30 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.wednesdayAM addGestureRecognizer:singleTap30];
    [singleTap30 release];
    UITapGestureRecognizer* singleTap31 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.wednesdayPM addGestureRecognizer:singleTap31];
    [singleTap31 release];
    
    UITapGestureRecognizer* singleTap40 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.thursdayAM addGestureRecognizer:singleTap40];
    [singleTap40 release];
    UITapGestureRecognizer* singleTap41 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.thursdayPM addGestureRecognizer:singleTap41];
    [singleTap41 release];
    
    UITapGestureRecognizer* singleTap50 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fridayAM addGestureRecognizer:singleTap50];
    [singleTap50 release];
    UITapGestureRecognizer* singleTap51 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fridayPM addGestureRecognizer:singleTap51];
    [singleTap51 release];
    
    UITapGestureRecognizer* singleTap60 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.saturdayAM addGestureRecognizer:singleTap60];
    [singleTap60 release];
    UITapGestureRecognizer* singleTap61 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.saturdayPM addGestureRecognizer:singleTap61];
    [singleTap61 release];
    
    UITapGestureRecognizer* singleTap70 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.sundayAM addGestureRecognizer:singleTap70];
    [singleTap70 release];
    UITapGestureRecognizer* singleTap71 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.sundayPM addGestureRecognizer:singleTap71];
    [singleTap71 release];
    self.labelList = [NSMutableArray arrayWithObjects:self.mondayAM, self.mondayPM, self.tuesdayAM, self.tuesdayPM, self.wednesdayAM, self.wednesdayPM, self.thursdayAM, self.thursdayPM, self.fridayAM, self.fridayPM, self.saturdayAM, self.saturdayPM, self.sundayAM, self.sundayPM, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.weeklyMainTemplateDataManager = nil;
    for (int i = 0; i < [self.labelList count]; i++) {
        UILabel* auxLabel = [self.labelList objectAtIndex:i];
        for (UIGestureRecognizer* recognizer in auxLabel.gestureRecognizers) {
            [auxLabel removeGestureRecognizer:recognizer];
        }
    }    
    self.labelList = nil;
    self.viewList = nil;
    
    self.headingDesc = nil;
    self.headingTemplateAM = nil;
    self.headingChildTemplatePM = nil;
    self.headingButtonAM = nil;
    self.headingAM = nil;
    self.headingSpace = nil;
    self.headingTemplatePM = nil;
    self.headingChildTemplatePM = nil;
    self.headingButtonPM = nil;
    self.headingPM = nil;
    self.headingView = nil;
    
    self.weekdayTemplateView = nil;
    
    self.mondayDesc = nil;
    self.mondayAM = nil;
    self.mondaySpace = nil;
    self.mondayPM = nil;
    self.mondayView = nil;
    self.mondayTemplateView = nil;
    
    self.tuesdayDesc = nil;
    self.tuesdayAM = nil;
    self.tuesdaySpace = nil;
    self.tuesdayPM = nil;
    self.tuesdayView = nil;
    self.tuesdayTemplateView = nil;
    
    self.wednesdayDesc = nil;
    self.wednesdayAM = nil;
    self.wednesdaySpace = nil;
    self.wednesdayPM = nil;
    self.wednesdayView = nil;
    self.wednesdayTemplateView = nil;
    
    self.thursdayDesc = nil;
    self.thursdayAM = nil;
    self.thursdaySpace = nil;
    self.thursdayPM = nil;
    self.thursdayView = nil;
    self.thursdayTemplateView = nil;
    
    self.fridayDesc = nil;
    self.fridayAM = nil;
    self.fridaySpace = nil;
    self.fridayPM = nil;
    self.fridayView = nil;
    self.fridayTemplateView = nil;
    
    self.saturdayDesc = nil;
    self.saturdayAM = nil;
    self.saturdaySpace = nil;
    self.saturdayPM = nil;
    self.saturdayView = nil;
    self.saturdayTemplateView = nil;
    
    self.sundayDesc = nil;
    self.sundayAM = nil;
    self.sundaySpace = nil;
    self.sundayPM = nil;
    self.sundayView = nil;
    self.sundayTemplateView = nil;
    
    self.footerThisWeekHeading = nil;
    self.footerHeadingSpace = nil;
    self.footerMonthToDateHeading = nil;
    self.footerOnTerritoryDesc = nil;
    self.footerOnTerritoryThisWeekFigure = nil;
    self.footerOnTerritorySpace = nil;
    self.footerOnTerritoryMonthToDateFigure = nil;
    self.footerOffTerritoryDesc = nil;
    self.footerOffTerritoryThisWeekFigure = nil;
    self.footerOffTerritorySpace = nil;
    self.footerOffTerritoryMonthToDateFigure = nil;
    self.footerView = nil;
    
    self.currentLabel = nil;
    self.weeklyDayPartsDataManager = nil;
    
    [super dealloc];
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    self.currentLabel = (UILabel*)recognizer.view;
    
    NSMutableArray* auxDataList = [self.weeklyMainTemplateDataManager retrieveDayPartsDictList];
    NSString* auxTitle = [self.weeklyMainTemplateDataManager retrieveDayPartsTitle];
    
    TableWidgetViewController* tableWidgetViewController = [[TableWidgetViewController alloc] initWithDataList:auxDataList withTitle:auxTitle withParentContentString:self.currentLabel.text];
    float contentSizeHeight = 44.0 * ([auxDataList count] + 3);
    tableWidgetViewController.preferredContentSize = CGSizeMake(380.0f, contentSizeHeight);
    tableWidgetViewController.delegate = self;
    tableWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    tableWidgetViewController.popoverPresentationController.sourceView = self.currentLabel;
    [self presentViewController:tableWidgetViewController animated:YES completion:^{
        
    }];
    [tableWidgetViewController release];
}

#pragma mark WidgetViewControllerDelegate
- (void)operationDone:(id)data {
    self.currentLabel.text = [data objectForKey:@"Title"];
    [self.weeklyMainTemplateDataManager updateChangedData:data withTag:[NSNumber numberWithInteger:self.currentLabel.tag]];
    [self configDayPartsColorWithDict:data label:self.currentLabel];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self calculateThisWeekFigure];
}

- (void)dismissPopoverController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)reloadDayPartsData {
    for (int i = 0; i < [self.weeklyMainTemplateDataManager.daysOfWeekKeyList count]; i++) {
        NSNumber* auxDayKey = [self.weeklyMainTemplateDataManager.daysOfWeekKeyList objectAtIndex:i];
        UILabel* auxDayLabel = (UILabel*)[self.view viewWithTag:[auxDayKey integerValue]];
        NSMutableDictionary* auxDaysOfWeekDataDict = [self.weeklyMainTemplateDataManager.dayPartsGroupedDataDict objectForKey:auxDayKey];
        NSMutableDictionary* auxDaysOfWeekCompositeContentDataDict = [auxDaysOfWeekDataDict objectForKey:@"Data"];             
        auxDayLabel.text = [auxDaysOfWeekCompositeContentDataDict objectForKey:@"Title"];
        [self configDayPartsColorWithDict:auxDaysOfWeekCompositeContentDataDict label:auxDayLabel];
    }
    [self calculateThisWeekFigure];
}

- (void)calculateThisWeekFigure {
    float onTerritoryValue = 0.0f;
    float offTerritoryValue = 0.0f;
    for (int i = 0; i < [self.weeklyMainTemplateDataManager.daysOfWeekKeyList count]; i++) {
        NSNumber* auxDayKey = [self.weeklyMainTemplateDataManager.daysOfWeekKeyList objectAtIndex:i];
        NSMutableDictionary* auxDaysOfWeekDataDict = [self.weeklyMainTemplateDataManager.dayPartsGroupedDataDict objectForKey:auxDayKey];
        NSMutableDictionary* auxDaysOfWeekCompositeContentDataDict = [auxDaysOfWeekDataDict objectForKey:@"Data"];
        NSString* auxDescrDetailCode = [ArcosUtils trim:[auxDaysOfWeekCompositeContentDataDict objectForKey:@"DescrDetailCode"]];
        if ([auxDescrDetailCode isEqualToString:self.weeklyMainTemplateDataManager.weekdayCode]) {
            onTerritoryValue += 0.5;
        }        
    }
    offTerritoryValue = 7.0 - onTerritoryValue;
    self.footerOnTerritoryThisWeekFigure.text = [NSString stringWithFormat:@"%.1f", onTerritoryValue];
    self.footerOffTerritoryThisWeekFigure.text = [NSString stringWithFormat:@"%.1f", offTerritoryValue];
}

- (void)configDayPartsColorWithDict:(NSMutableDictionary*)aDaysOfWeekCompositeContentDataDict label:(UILabel*)aLabel {
    NSString* auxDescrDetailCode = [ArcosUtils trim:[aDaysOfWeekCompositeContentDataDict objectForKey:@"DescrDetailCode"]];
    if ([auxDescrDetailCode isEqualToString:self.weeklyMainTemplateDataManager.weekdayCode]) {
        aLabel.textColor = [UIColor blueColor];
    } else if ([auxDescrDetailCode isEqualToString:self.weeklyMainTemplateDataManager.weekendCode]) {
        aLabel.textColor = [UIColor grayColor];
    } else {
        aLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
    }
}

@end
