//
//  DetailingMainTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingMainTableCell.h"


@implementation DetailingMainTableCell
@synthesize OrderDate;
@synthesize CallType;
@synthesize Contact;
@synthesize Memo;
@synthesize factory;
@synthesize thePopover = _thePopover;
//@synthesize cellData;
@synthesize orderDateTitle = _orderDateTitle;
@synthesize callTypeTitle = _callTypeTitle;
@synthesize contactTitle = _contactTitle;
@synthesize memoTitle = _memoTitle;

@synthesize dueDateTitle = _dueDateTitle;
@synthesize taskTypeTitle = _taskTypeTitle;
@synthesize employeeTitle = _employeeTitle;
@synthesize detailsTitle = _detailsTitle;

@synthesize dueDateContent = _dueDateContent;
@synthesize taskTypeContent = _taskTypeContent;
@synthesize employeeContent = _employeeContent;
@synthesize detailsContent = _detailsContent;

@synthesize secondFieldList = _secondFieldList;
@synthesize thirdFieldList = _thirdFieldList;
@synthesize fourthFieldList = _fourthFieldList;

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
    self.secondFieldList = [NSMutableArray arrayWithObjects:self.OrderDate, self.CallType, self.Contact, self.Memo, nil];
    self.thirdFieldList = [NSMutableArray arrayWithObjects:self.dueDateTitle, self.taskTypeTitle, self.employeeTitle, self.detailsTitle, nil];
    self.fourthFieldList = [NSMutableArray arrayWithObjects:self.dueDateContent, self.taskTypeContent, self.employeeContent, self.detailsContent, nil];
    self.cellData=theData;
    //textview outline
    self.Memo.layer.borderWidth=0.5f;
    self.Memo.layer.borderColor=[[UIColor greenColor]CGColor];
    [self.Memo.layer setCornerRadius:5.0f];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] disableMemoFlag]) {
        self.memoTitle.hidden = NO;
        self.Memo.hidden = NO;
    } else {
        self.memoTitle.hidden = YES;
        self.Memo.hidden = YES;
    }
    self.detailsContent.layer.borderWidth = 0.5f;
    self.detailsContent.layer.borderColor = [[UIColor greenColor]CGColor];
    [self.detailsContent.layer setCornerRadius:5.0f];
    //fill the data
    if ([theData objectForKey:@"data"]!=nil) {
        NSMutableDictionary* aData=[theData objectForKey:@"data"];
        if ([aData objectForKey:@"OrderDate"]!=nil) {
            NSDate* theOrderDate=[aData objectForKey:@"OrderDate"];
            NSString* myDateFormat = [GlobalSharedClass shared].dateFormat;
            if ([ArcosConfigDataManager sharedArcosConfigDataManager].includeCallTimeFlag) {
                myDateFormat = [GlobalSharedClass shared].datetimehmFormat;
            }
            self.OrderDate.text = [ArcosUtils stringFromDate:theOrderDate format:myDateFormat];
        }
        if ([aData objectForKey:@"CallType"]!=nil) {
            NSMutableDictionary* theCalltype=[aData objectForKey:@"CallType"];
            self.CallType.text=[theCalltype objectForKey:@"Detail"];
        }
        if ([aData objectForKey:@"Contact"]!=nil) {
            NSMutableDictionary* theContact=[aData objectForKey:@"Contact"];
            self.Contact.text=[theContact objectForKey:@"Title"];
        }
        if ([aData objectForKey:@"Memo"]!=nil) {
            NSString* theMemo=[aData objectForKey:@"Memo"];
            self.Memo.text=theMemo;
        }
        NSMutableArray* invoiceRefList = [aData objectForKey:@"invoiceRef"];
        if (invoiceRefList != nil) {
            @try {
                self.detailsContent.text = [invoiceRefList objectAtIndex:0];
                NSNumber* employeeIUR = [invoiceRefList objectAtIndex:1];
                NSString* employeeName = @"";
                if ([employeeIUR intValue] != 0) {
                    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
                    if (employeeDict != nil) {
                        employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
                    }
                }
                self.employeeContent.text = employeeName;
                NSNumber* taskTypeIUR = [invoiceRefList objectAtIndex:2];
                NSString* taskTypeDesc = @"";
                if ([taskTypeIUR intValue] != 0) {
                    NSDictionary* taskTypeDescrDetail = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:taskTypeIUR];
                    taskTypeDesc = [ArcosUtils convertNilToEmpty:[taskTypeDescrDetail objectForKey:@"Detail"]];
                }
                self.taskTypeContent.text = taskTypeDesc;
                self.dueDateContent.text = [invoiceRefList objectAtIndex:3];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    for (UIGestureRecognizer* recognizer in self.CallType.gestureRecognizers) {
        [self.CallType removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.Contact.gestureRecognizers) {
        [self.Contact removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.OrderDate.gestureRecognizers) {
        [self.OrderDate removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.dueDateContent.gestureRecognizers) {
        [self.dueDateContent removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.taskTypeContent.gestureRecognizers) {
        [self.taskTypeContent removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.employeeContent.gestureRecognizers) {
        [self.employeeContent removeGestureRecognizer:recognizer];
    }
    //add taps action
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.CallType addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.Contact addGestureRecognizer:singleTap1];

    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.OrderDate addGestureRecognizer:singleTap2];
    
    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.dueDateContent addGestureRecognizer:singleTap3];
    
    UITapGestureRecognizer* singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.taskTypeContent addGestureRecognizer:singleTap4];
    
    UITapGestureRecognizer* singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.employeeContent addGestureRecognizer:singleTap5];
    
    [singleTap release];
    [singleTap1 release];
    [singleTap2 release];
    [singleTap3 release];
    [singleTap4 release];
    [singleTap5 release];
    
    //check is editable
    if (!self.isEditable) {
        [self disableEditing];
    }
    
}
-(void)disableEditing{
    self.Memo.editable=NO;
}
-(void)handleSingleTapGesture:(id)sender{
    if (!self.isEditable) {//if it not editable then return
        return;
    }
    
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    UILabel* aLabel=(UILabel*)reconizer.view;
    currentLabelIndex=aLabel.tag;
    
    [self.delegate editStartForIndexpath:self.indexPath];
    
//    NSLog(@"single tap is found on %d",aLabel.tag);
    if (self.factory==nil) {
        self.factory=[WidgetFactory factory];
        self.factory.delegate=self;
    }
    
    /*
    if (aLabel.tag==0) {
        self.thePopover=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
        
    }else if (aLabel.tag == 1){
        NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:self.locationIUR];
        [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
        NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
        [miscDataDict setObject:@"Contact" forKey:@"Title"];
        [miscDataDict setObject:self.locationIUR forKey:@"LocationIUR"];
        [miscDataDict setObject:self.locationName forKey:@"Name"];
        self.thePopover =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
    } else {
        if (self.orderNumber == nil) {
            self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate pickerFormatType:DatePickerFormatDateTime];
        } else {
            NSDate* tmpOrderDate = [self.cellData valueForKeyPath:@"data.OrderDate"];
            self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate pickerFormatType:DatePickerFormatDateTime defaultPickerDate:tmpOrderDate];
        }
    }
    */
    switch (aLabel.tag) {
        case 0: {
            self.thePopover=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
        }
            break;
        case 1: {
            NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:self.locationIUR];
            [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
            NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
            [miscDataDict setObject:@"Contact" forKey:@"Title"];
            [miscDataDict setObject:self.locationIUR forKey:@"LocationIUR"];
            [miscDataDict setObject:self.locationName forKey:@"Name"];
            self.thePopover =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
        }
            break;
        case 2: {
            if (self.orderNumber == nil) {
                self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate pickerFormatType:DatePickerFormatDateTime];
            } else {
                NSDate* tmpOrderDate = [self.cellData valueForKeyPath:@"data.OrderDate"];
                self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate pickerFormatType:DatePickerFormatDateTime defaultPickerDate:tmpOrderDate];
            }
        }
            break;
        case 3: {
            self.thePopover = [self.factory CreateDateWidgetWithDataSource:2 defaultPickerDate:[ArcosUtils dateFromString:self.dueDateContent.text format:[GlobalSharedClass shared].dateFormat]];
        }
            break;
        case 4: {
            NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:@"TY"];
            NSDictionary* descrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"TY"];
            NSString* myTitle = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
            self.thePopover = [self.factory CreateGenericCategoryWidgetWithPickerValue:descrDetailList title:myTitle];
        }
            break;
        case 5: {
            NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
            self.thePopover = [self.factory CreateGenericCategoryWidgetWithPickerValue:employeeList title:@"Employee"];
        }
            break;
            
        default:
            break;
    }
    
    //[self showWidget];
    //popover is shown
    if (self.thePopover!=nil) {
        [self.delegate popoverShows:self.thePopover];
    }else{
        if (aLabel.tag == 1) {
            self.Contact.text=@"No contact found";
            
            //contact is not found in the DB
            NSMutableDictionary* MData=[self.cellData objectForKey:@"data"];
            if (MData==nil) {
                MData=[NSMutableDictionary dictionary];
            }
            [MData setObject:[NSMutableDictionary dictionaryWithObject:@"No contact found" forKey:@"Title"] forKey:@"Contact"];
            [self.delegate inputFinishedWithData:MData forIndexpath:self.indexPath];
        }
    }
    
    //do show the popover if there is no data
    if (self.thePopover!=nil) {
        self.thePopover.delegate=self;
        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
}
#pragma mark widget factory delegate
-(void)operationDone:(id)data{
//    NSLog(@"widget pick the data %@",data);
    if (self.thePopover!=nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    
    //save the data to the cell data dictionary
    
    NSMutableDictionary* MData=[self.cellData objectForKey:@"data"];
    if (MData==nil) {
        MData=[NSMutableDictionary dictionary];
    }
    
    if (currentLabelIndex==0) {
        NSString* calltype=[data objectForKey:@"Title"];
        self.CallType.text=calltype;
        [MData setObject:data forKey:@"CallType"];

    }
    if (currentLabelIndex==1) {
        NSString* aContact=[data objectForKey:@"Title"];
        self.Contact.text=aContact;
        [MData setObject:data forKey:@"Contact"];
        [GlobalSharedClass shared].currentSelectedContactIUR = [data objectForKey:@"IUR"];
    }
    if (currentLabelIndex==2) {
        NSString* myDateFormat = [GlobalSharedClass shared].dateFormat;
        if ([ArcosConfigDataManager sharedArcosConfigDataManager].includeCallTimeFlag) {
            myDateFormat = [GlobalSharedClass shared].datetimehmFormat;
        }
        self.OrderDate.text = [ArcosUtils stringFromDate:data format:myDateFormat];
        [MData setObject:data forKey:@"OrderDate"];
    }
    if (currentLabelIndex==3) {
        self.dueDateContent.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].dateFormat];
        NSMutableArray* invoiceRefList = [MData objectForKey:@"invoiceRef"];
        [invoiceRefList replaceObjectAtIndex:3 withObject:self.dueDateContent.text];
    }
    if (currentLabelIndex==4) {
        self.taskTypeContent.text = [data objectForKey:@"Title"];
        NSMutableArray* invoiceRefList = [MData objectForKey:@"invoiceRef"];
        [invoiceRefList replaceObjectAtIndex:2 withObject:[data objectForKey:@"DescrDetailIUR"]];
    }
    if (currentLabelIndex==5) {
        self.employeeContent.text = [data objectForKey:@"Title"];
        NSMutableArray* invoiceRefList = [MData objectForKey:@"invoiceRef"];
        [invoiceRefList replaceObjectAtIndex:1 withObject:[data objectForKey:@"IUR"]];
    }

   // NSLog(@"detailing cell data is %@",self.cellData);
    [self.delegate inputFinishedWithData:MData forIndexpath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

-(BOOL)allowToShowAddContactButton {
    if (self.orderNumber != nil) {
        return NO;
    } else {
        return YES;
    }    
}
-(IBAction)memoInput:(id)sender{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    //[self.cellData setObject:textView.text forKey:@"memo"];
    
//    NSLog(@"detailing cell data is %@",self.cellData);
    
    NSMutableDictionary* MData=[self.cellData objectForKey:@"data"];
    if (MData==nil) {
        MData=[NSMutableDictionary dictionary];
    }
    if (textView.tag == 1) {
        NSMutableArray* invoiceRef = [MData objectForKey:@"invoiceRef"];
        [invoiceRef replaceObjectAtIndex:0 withObject:textView.text];
    } else {
        [MData setObject:textView.text forKey:@"Memo"];
    }
    [self.delegate inputFinishedWithData:MData forIndexpath:self.indexPath];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 1) {
        NSUInteger originalLength = [text length];
        text = [text stringByReplacingOccurrencesOfString:@"|" withString:@""];
        NSUInteger nextLength = [text length];
        if (originalLength != nextLength) {
            NSUInteger oldLength = [textView.text length];
            NSUInteger replacementLength = [text length];
            NSUInteger rangeLength = range.length;
            NSUInteger newLength = oldLength - rangeLength + replacementLength;
            BOOL memoResultFlag = (newLength <= [GlobalSharedClass shared].memoDetailMaxLength);
            if (!memoResultFlag) {
                NSUInteger currentLength = oldLength - rangeLength;
                NSUInteger allowedAddedLength = 0;
                if ([GlobalSharedClass shared].memoDetailMaxLength > currentLength) {
                    allowedAddedLength = [GlobalSharedClass shared].memoDetailMaxLength - currentLength;
                }
                textView.text = [textView.text stringByReplacingCharactersInRange:range withString:[text substringToIndex:allowedAddedLength]];
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Maximum text length of %d characters has been exceeded, data has been truncated", [GlobalSharedClass shared].memoDetailMaxLength] title:@"" delegate:nil target:[self.delegate retrieveParentViewController] tag:0 handler:^(UIAlertAction *action) {
                    
                }];
            } else {
                textView.text = [textView.text stringByReplacingCharactersInRange:range withString:text];
            }
            return NO;
        }
        return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.delegate retrieveParentViewController]];
    } else {
        return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:[self.delegate retrieveParentViewController]];
    }
}
- (void)dealloc
{
    if (self.OrderDate != nil) { self.OrderDate = nil; }
    if (self.CallType != nil) { self.CallType = nil; }
    if (self.Contact != nil) { self.Contact = nil; }
    if (self.Memo != nil) { self.Memo = nil; }
    if (self.factory != nil) { self.factory = nil; }
    self.thePopover = nil;
    self.orderDateTitle = nil;
    self.callTypeTitle = nil;
    self.contactTitle = nil;
    self.memoTitle = nil;
    
    self.dueDateTitle = nil;
    self.taskTypeTitle = nil;
    self.employeeTitle = nil;
    self.detailsTitle = nil;
    self.dueDateContent = nil;
    self.taskTypeContent = nil;
    self.employeeContent = nil;
    self.detailsContent = nil;
    
    self.secondFieldList = nil;
    self.thirdFieldList = nil;
    self.fourthFieldList = nil;
    
    [super dealloc];
}

- (void)layoutMySubviews:(NSString*)anActionType {
    if (![anActionType isEqualToString:@"create"]) return;
    float width = self.contentView.frame.size.width;
    float halfWidth = width / 2.0;
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag]) {
        for (int i = 0; i < [self.secondFieldList count]; i++) {
            UIView* auxUIView = [self.secondFieldList objectAtIndex:i];
            auxUIView.frame = CGRectMake(auxUIView.frame.origin.x, auxUIView.frame.origin.y, halfWidth - auxUIView.frame.origin.x - 5.0, auxUIView.frame.size.height);
        }
        for (int i = 0; i < [self.thirdFieldList count]; i++) {
            UIView* auxUIView = [self.thirdFieldList objectAtIndex:i];
            auxUIView.hidden = NO;
            auxUIView.frame = CGRectMake(halfWidth, auxUIView.frame.origin.y, 90.0, auxUIView.frame.size.height);
        }
        for (int i = 0; i < [self.fourthFieldList count]; i++) {
            UIView* auxUIView = [self.fourthFieldList objectAtIndex:i];
            auxUIView.hidden = NO;
            auxUIView.frame = CGRectMake(halfWidth + 95.0, auxUIView.frame.origin.y, halfWidth - 110.0, auxUIView.frame.size.height);
        }
    } else {
        for (int i = 0; i < [self.secondFieldList count]; i++) {
            UIView* auxUIView = [self.secondFieldList objectAtIndex:i];
            auxUIView.frame = CGRectMake(auxUIView.frame.origin.x, auxUIView.frame.origin.y, width - auxUIView.frame.origin.x - 15, auxUIView.frame.size.height);
        }
        for (int i = 0; i < [self.thirdFieldList count]; i++) {
            UIView* auxUIView = [self.thirdFieldList objectAtIndex:i];
            auxUIView.hidden = YES;
        }
        for (int i = 0; i < [self.fourthFieldList count]; i++) {
            UIView* auxUIView = [self.fourthFieldList objectAtIndex:i];
            auxUIView.hidden = YES;
        }
    }
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
