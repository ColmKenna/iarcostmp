//
//  DetailingKMTableCell.m
//  Arcos
//
//  Created by Apple on 02/02/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "DetailingKMTableCell.h"
#import "ArcosConfigDataManager.h"

@implementation DetailingKMTableCell
@synthesize label;
@synthesize statusLabel;
@synthesize factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize kmCellData = _kmCellData;
@synthesize answerObjectList = _answerObjectList;
@synthesize answerSegmentedControl = _answerSegmentedControl;

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

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.kmCellData = theData;
    self.label.text=[theData objectForKey:@"Label"];
    self.answerObjectList = [self retrieveAnswerObjectList];
    int contentLength = 0;
    for (int i = 0; i < [self.answerObjectList count]; i++) {
        NSMutableDictionary* tmpAnswerObjectDict = [self.answerObjectList objectAtIndex:i];
        contentLength += [[ArcosUtils convertNilToEmpty:[tmpAnswerObjectDict objectForKey:@"Detail"]] length];
    }
    if (contentLength <= [GlobalSharedClass shared].callEntrySelectionBoxLength && [[ArcosConfigDataManager sharedArcosConfigDataManager] enableSelectionBoxInCallEntryFlag]) {
        self.answerSegmentedControl.enabled = self.isEditable;
        self.answerSegmentedControl.hidden = NO;
        self.statusLabel.hidden = YES;
        [self.answerSegmentedControl removeAllSegments];        
        for (int i = 0; i < [self.answerObjectList count]; i++) {
            NSMutableDictionary* auxAnswerObjectDict = [self.answerObjectList objectAtIndex:i];
            [self.answerSegmentedControl insertSegmentWithTitle:[auxAnswerObjectDict objectForKey:@"Title"] atIndex:i animated:NO];
        }
    } else {
        self.answerSegmentedControl.hidden = YES;
        self.statusLabel.hidden = NO;
    }
    
    NSMutableDictionary* answerData=[theData objectForKey:@"data"];
    if (answerData!=nil) {
        NSString* tmpDescrDetailCode = [self.kmCellData objectForKey:@"DescrDetailCode"];
        if (![tmpDescrDetailCode containsString:@"*"]) {
            self.statusLabel.text=[answerData objectForKey:@"Detail"];
            int auxSegmentedIndex = [self retrieveIndexByTitle:[answerData objectForKey:@"Detail"]];
            if (auxSegmentedIndex != -1) {
                self.answerSegmentedControl.selectedSegmentIndex = auxSegmentedIndex;
            } else {
                [self.answerSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
            }
        } else {
            NSMutableArray* msdata = [answerData objectForKey:@"msdata"];
            NSMutableArray* labelTextList = [NSMutableArray arrayWithCapacity:[msdata count]];
            for (int i = 0; i < [msdata count]; i++) {
                NSMutableDictionary* tmpDescrDetailDict = [msdata objectAtIndex:i];
                [labelTextList addObject:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"Detail"]]];
            }
            self.statusLabel.text = [labelTextList componentsJoinedByString:@","];
        }
        [self.statusLabel setTextColor:[UIColor redColor]];
    }else{
        self.statusLabel.text=@"Select an answer";
        [self.statusLabel setTextColor:[UIColor blueColor]];
        [self.answerSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
    
    //add taps action
    NSArray* recognizerList = self.statusLabel.gestureRecognizers;
    for (UITapGestureRecognizer* tmpRecognizer in recognizerList) {
        if ([tmpRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.statusLabel removeGestureRecognizer:tmpRecognizer];
        }
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.statusLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender{
    //[self.delegate editStartForIndexpath:self.indexPath];
    if (!self.isEditable) {//if it not editable then return
        return;
    }
    
    NSLog(@"single tap is found on %@",[self.cellData objectForKey:@"Label"]);
    if (self.factory==nil) {
        self.factory=[WidgetFactory factory];
        self.factory.delegate=self;
    }
    //[self showWidget];
    
    
    NSString* titleString = @"";
    NSDictionary* descrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"KM"];
    if (descrTypeDict != nil) {
        titleString = [descrTypeDict objectForKey:@"Details"];
    }
    NSString* tmpDescrDetailCode = [self.kmCellData objectForKey:@"DescrDetailCode"];
    if (![tmpDescrDetailCode containsString:@"*"]) {
        self.globalWidgetViewController = [self.factory CreateGenericCategoryWidgetWithPickerValue:self.answerObjectList title:titleString];
    } else {
        NSMutableArray* parentItemList = [NSMutableArray array];
        self.globalWidgetViewController = [self.factory CreateGenericTableMSWidgetWithData:self.answerObjectList withTitle:titleString withParentItemList:parentItemList];
    }
    //    thePopover=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceDetaillingQA];
    
    //popover is shown
//    if (self.thePopover!=nil) {
//        [self.delegate popoverShows:self.thePopover];
//    }
    
    //do show the popover if there is no data
    if (self.globalWidgetViewController!=nil) {
//        self.thePopover.delegate=self;
//        [self.thePopover presentPopoverFromRect:self.statusLabel.bounds inView:self.statusLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.statusLabel;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.statusLabel.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}


#pragma mark widget factory delegate
-(void)operationDone:(id)data{
    
    self.cellData=data;
    
    //    NSLog(@"widget pick the data %@",data);
//    if (self.thePopover!=nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    //set the label text  (bad fit)
    NSString* tmpDescrDetailCode = [self.kmCellData objectForKey:@"DescrDetailCode"];
    if (![tmpDescrDetailCode containsString:@"*"]) {
        NSString* labelText=[(NSMutableDictionary*)data objectForKey:@"Detail"];
        self.statusLabel.text=labelText;
        [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
    } else {
        NSMutableArray* labelTextList = [NSMutableArray arrayWithCapacity:[data count]];
        for (int i = 0; i < [data count]; i++) {
            NSMutableDictionary* tmpDescrDetailDict = [data objectAtIndex:i];
            [labelTextList addObject:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"Detail"]]];
        }
        self.statusLabel.text = [labelTextList componentsJoinedByString:@","];
        NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [resultDict setObject:data forKey:@"msdata"];
        [self.delegate inputFinishedWithData:resultDict forIndexpath:self.indexPath];
    }
    
    [self.statusLabel setTextColor:[UIColor redColor]];
    //send the data back (bad fit)
//    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

- (void)dismissPopoverController {
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:^ {
        self.globalWidgetViewController = nil;
    }];
}

- (NSString*)reuseIdentifier {
    return @"DetailingKMTableCell";
}

- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.statusLabel != nil) { self.statusLabel = nil; }
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.kmCellData = nil;
    self.answerObjectList = nil;
    self.answerSegmentedControl = nil;
    
    [super dealloc];
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

- (IBAction)segmentedValueChange:(id)sender {
    NSMutableDictionary* selectedAnswerObject = [self.answerObjectList objectAtIndex:self.answerSegmentedControl.selectedSegmentIndex];
    [self.delegate inputFinishedWithData:selectedAnswerObject forIndexpath:self.indexPath];
}

- (NSMutableArray*)retrieveAnswerObjectList {
    NSMutableArray* objectsArray = nil;
    NSNumber* descrDetailIUR = [self.kmCellData objectForKey:@"DescIUR"];
    NSDictionary* descrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:descrDetailIUR];
    if (descrDetailDict != nil) {
        NSString* descrDetailCode = [ArcosUtils trim:[descrDetailDict objectForKey:@"DescrDetailCode"]];
        //            NSLog(@"parentCode: %@", parentCode);
        NSPredicate* predicateParentCode = [NSPredicate predicateWithFormat:@"DescrTypeCode='KM' and Active=1 and ParentCode = %@", descrDetailCode];
        NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
        objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicateParentCode withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
        
        if ([objectsArray count] == 0) {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='KM' and Active=1"];
            objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
        }
    }
    
    NSMutableArray* tmpObjectArray = [ArcosUtils addOneFieldToObjectsArray:objectsArray fromFieldName:@"Detail" toFieldName:@"Title"];
    NSMutableArray* resObjectArray = [ArcosUtils addOneNumberFieldToObjectArray:tmpObjectArray fromFieldName:@"DescrDetailIUR" toFieldName:@"IUR"];
    return resObjectArray;
}

- (int)retrieveIndexByTitle:(NSString*)aTitle {
    int auxIndex = -1;
    for (int i = 0; i < [self.answerObjectList count]; i++) {
        NSMutableDictionary* auxAnswerObjectDict = [self.answerObjectList objectAtIndex:i];
        if ([aTitle isEqualToString:[auxAnswerObjectDict objectForKey:@"Title"]]) {
            auxIndex = i;
            break;
        }
    }
    return auxIndex;
}

- (NSMutableDictionary*)retrieveDataByIndex:(int)anIndex {
    return [self.answerObjectList objectAtIndex:anIndex];
}

@end
