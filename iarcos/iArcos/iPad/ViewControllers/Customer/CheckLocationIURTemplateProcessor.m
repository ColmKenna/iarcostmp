//
//  CheckLocationIURTemplateProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CheckLocationIURTemplateProcessor.h"
#import "ArcosRootViewController.h"
@interface CheckLocationIURTemplateProcessor () {
    NSString* _currentSelectedCustomerName;
    NSString* _myNewLocationName;
    ArcosRootViewController* _arcosRootViewController;
    NSMutableDictionary* _vowelDict;
}
@property(nonatomic, retain) NSString* currentSelectedCustomerName;
@property(nonatomic, retain) NSString* myNewLocationName;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) NSMutableDictionary* vowelDict;

//- (BOOL)checkLocationCode:(NSNumber*)aLocationIUR;
//- (BOOL)checkCreditStatus:(NSNumber*)aLocationIUR;
- (void)buildCandidateSubMenuItemList;
- (NSMutableDictionary*)createCandidateSubMenuItemDict:(NSNumber*)aLocationIUR title:(NSString*)aTitle;
- (void)checkSubMenuItemInstance:(int)aRowPointer;
- (BOOL)checkVowels:(NSString*)aTitle;
- (void)ignoreActionCallBack;
@end


@implementation CheckLocationIURTemplateProcessor
@synthesize delegate = _delegate;
@synthesize myParentViewController = _myParentViewController;
@synthesize candidateSubMenuItemList = _candidateSubMenuItemList;
@synthesize rowPointer = _rowPointer;
@synthesize currentSelectedCustomerName = _currentSelectedCustomerName;
@synthesize myNewLocationName = _myNewLocationName;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize vowelDict = _vowelDict;
@synthesize previewIndexPath = _previewIndexPath;

- (id)initWithParentViewController:(UIViewController*)aParentViewController {
    self = [super init];
    if (self != nil) {
        self.myParentViewController = aParentViewController;
        self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
        self.vowelDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [self.vowelDict setObject:@"A" forKey:@"A"];
        [self.vowelDict setObject:@"E" forKey:@"E"];
        [self.vowelDict setObject:@"I" forKey:@"I"];
        [self.vowelDict setObject:@"O" forKey:@"O"];
        [self.vowelDict setObject:@"U" forKey:@"U"];
    }
    
    return self;
}

- (void)dealloc {
    self.myParentViewController = nil;
    self.candidateSubMenuItemList = nil;
    self.currentSelectedCustomerName = nil;
    self.myNewLocationName = nil;
    self.arcosRootViewController = nil;
    self.vowelDict = nil;
    self.previewIndexPath = nil;
    
    [super dealloc];
}

- (void)checkLocationIUR:(NSNumber*)aNewLocationIUR locationName:(NSString*)aNewLocationName indexPath:(NSIndexPath*)anIndexPath{
    self.previewIndexPath = anIndexPath;
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        if ([[GlobalSharedClass shared].currentSelectedLocationIUR intValue] == [aNewLocationIUR intValue]) {//same customer
            //redirct to the order pad
            [self.delegate succeedToCheckSameLocationIUR:anIndexPath];
        }else{
            self.myNewLocationName = aNewLocationName;
            [self buildCandidateSubMenuItemList];
            self.rowPointer = 0;
            // open a dialog
            self.currentSelectedCustomerName = [[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
            if ([self.candidateSubMenuItemList count] > 0) {
                [self checkSubMenuItemInstance:self.rowPointer];
            } else {
                [self.arcosRootViewController.customerMasterViewController.subMenuListingTableViewController removeAllInstances];
                [self.delegate succeedToCheckNewLocationIUR:anIndexPath];
            }
        }
    }else{
        [self.delegate succeedToCheckNewLocationIUR:anIndexPath];
    }
}

//- (BOOL)checkLocationCode:(NSNumber*)aLocationIUR {
//    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:aLocationIUR];
//    if (locationList != nil) {
//        NSDictionary* locationDict = [locationList objectAtIndex:0];
//        //NSLog(@"locationDict: %@",locationDict);
//        NSString* tmpLocationCode = [locationDict objectForKey:@"LocationCode"];
//        NSString* locationCode = [tmpLocationCode uppercaseString];
//        if (locationCode != nil && [locationCode hasPrefix:@"HQ:"]) {
//            [ArcosUtils showMsg:@"Order Entry disabled for Head Office accounts" delegate:nil];
//            return NO;
//        }
//    }
//    return YES;
//}
//- (BOOL)checkCreditStatus:(NSNumber*)aLocationIUR {
//    NSDictionary* descDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:self.customerInfoTableDataManager.csIUR];
//    if (descDict != nil) {
//        NSNumber* codeType = [descDict objectForKey:@"CodeType"];
//        if ([codeType intValue] != 0) {
//            [ArcosUtils showMsg:[ArcosUtils convertNilToEmpty:[descDict objectForKey:@"Tooltip"] ]delegate:nil];
//        }
//        if ([codeType intValue] == 2) {
//            return NO;
//        }
//    }
//    return YES;
//}

- (void)buildCandidateSubMenuItemList {
    self.candidateSubMenuItemList = [NSMutableArray array];
    SubMenuListingTableViewController* tmpSubMenuListingTableViewController = self.arcosRootViewController.customerMasterViewController.subMenuListingTableViewController;
    NSMutableArray* subMenuDisplayList = tmpSubMenuListingTableViewController.displayList;
    NSMutableDictionary* subMenuRuleoutTitleDict = tmpSubMenuListingTableViewController.ruleoutTitleDict;
    NSString* myCustomControllerTitle = tmpSubMenuListingTableViewController.myCustomControllerTitle;
    if ([[OrderSharedClass sharedOrderSharedClass] anyOrderLine]) {
        [self.candidateSubMenuItemList addObject:[self createCandidateSubMenuItemDict:[GlobalSharedClass shared].currentSelectedLocationIUR title:tmpSubMenuListingTableViewController.orderTitle]];
    }
    for (int i = 0; i < [subMenuDisplayList count]; i++) {
        NSMutableDictionary* cellDict = [subMenuDisplayList objectAtIndex:i];
        NSString* subMenuTitle = [cellDict objectForKey:@"Title"];
        if ([subMenuRuleoutTitleDict objectForKey:subMenuTitle] != nil) continue;
        if ([cellDict objectForKey:myCustomControllerTitle] != nil) {
//            if ([subMenuTitle isEqualToString:tmpSubMenuListingTableViewController.orderTitle] && [GlobalSharedClass shared].currentSelectedOrderLocationIUR == nil) {
//                continue;
//            } else if ([subMenuTitle isEqualToString:tmpSubMenuListingTableViewController.presenterTitle] && [GlobalSharedClass shared].currentSelectedPresenterLocationIUR == nil) {
//                continue;
//            }
            if ([subMenuTitle isEqualToString:tmpSubMenuListingTableViewController.callTitle] && [GlobalSharedClass shared].currentSelectedCallLocationIUR == nil) {
                continue;
            } else if ([subMenuTitle isEqualToString:tmpSubMenuListingTableViewController.surveyTitle] && [GlobalSharedClass shared].currentSelectedSurveyLocationIUR == nil) {
                continue;
            }
            [self.candidateSubMenuItemList addObject:[self createCandidateSubMenuItemDict:[GlobalSharedClass shared].currentSelectedLocationIUR title:subMenuTitle]];
        }
    }
}

- (NSMutableDictionary*)createCandidateSubMenuItemDict:(NSNumber*)aLocationIUR title:(NSString*)aTitle {
    NSMutableDictionary* candidateSubMenuItemDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [candidateSubMenuItemDict setObject:aLocationIUR forKey:@"IUR"];
    [candidateSubMenuItemDict setObject:aTitle forKey:@"Title"];
    return candidateSubMenuItemDict;
}

- (void)checkSubMenuItemInstance:(int)aRowPointer {
    NSMutableDictionary* candidateSubMenuDict = [self.candidateSubMenuItemList objectAtIndex:aRowPointer];
    NSString* title = [candidateSubMenuDict objectForKey:@"Title"];
    BOOL vowelFlag = [self checkVowels:title];
    NSString* article = @"a";
    if (vowelFlag) {
        article = @"an";
    }
    
    NSString* message = [NSString stringWithFormat:@"You have %@ %@ in progress for %@!", article, title, self.currentSelectedCustomerName];
    
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* returnAction = [UIAlertAction actionWithTitle:@"Return" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self.delegate failToCheckLocationIUR:title];
    }];
    UIAlertAction* ignoreAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self ignoreActionCallBack];
    }];
    
    [tmpDialogBox addAction:returnAction];
    [tmpDialogBox addAction:ignoreAction];
    [self.myParentViewController presentViewController:tmpDialogBox animated:YES completion:nil];
//    if ([UIAlertController class]) {
//        
//    } else {
//        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Return" otherButtonTitles:@"Ignore", nil];
//        v.tag = 36;
//        [v show];
//        [v release];
//    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag != 36) return;
//    if (buttonIndex == [alertView cancelButtonIndex]) {
//        [self.delegate failToCheckLocationIUR];
//    } else {
//        [self ignoreActionCallBack];
//    }
//    
//}

- (void)ignoreActionCallBack {
    self.rowPointer++;
    if (self.rowPointer != [self.candidateSubMenuItemList count]) {
        [self checkSubMenuItemInstance:self.rowPointer];
    } else {//ignore all submenu
        [self.arcosRootViewController.customerMasterViewController.subMenuListingTableViewController removeAllInstances];
        [self.delegate succeedToCheckNewLocationIUR:self.previewIndexPath];
    }
}

- (BOOL)checkVowels:(NSString*)aTitle {
    BOOL resultFlag = NO;
    NSString* firstLetter = [aTitle substringToIndex:1];
    if ([self.vowelDict objectForKey:[firstLetter uppercaseString]] != nil) {
        return YES;
    }
    return resultFlag;
}

@end
