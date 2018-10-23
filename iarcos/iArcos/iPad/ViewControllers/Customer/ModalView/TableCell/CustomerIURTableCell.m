//
//  CustomerIURTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerIURTableCell.h"

@implementation CustomerIURTableCell
@synthesize fieldDesc;
@synthesize contentString;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;
@synthesize masterLocationDisplayList = _masterLocationDisplayList;
@synthesize callGenericServices = _callGenericService;
@synthesize headQuarterTitle = _headQuarterTitle;

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

- (void)dealloc
{
    if (self.fieldDesc != nil) { self.fieldDesc = nil; }            
    if (self.contentString != nil) { self.contentString = nil; }            
    if (self.factory != nil) { self.factory = nil; }            
    if (self.thePopover != nil) { self.thePopover = nil; }
    if (self.masterLocationDisplayList != nil) { self.masterLocationDisplayList = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.headQuarterTitle != nil) { self.headQuarterTitle = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    self.contentString.text = [theData objectForKey:@"contentString"];    
//    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    /*
    self.contentString.inputView = [[[UIView alloc] init] autorelease];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentString addGestureRecognizer:singleTap];
    [singleTap release];
    */
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.enabled = NO;
        self.contentString.textColor = [UIColor blackColor];
    }
//    if ([self.fieldDesc.text isEqualToString:@"Master Location"]) {
//        self.contentString.enabled = NO;
//    }    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Make a new view, or do what you want here
    if ([[self.cellData objectForKey:@"fieldDesc"] isEqualToString:@"Master Location"]) {
        [self processMasterLocationDescrSelectionPopover];
        return NO;
    }
    [self processDescrSelectionPopover];
    return NO;
}

-(void)handleSingleTapGesture:(id)sender {
    if ([[self.cellData objectForKey:@"fieldDesc"] isEqualToString:@"Master Location"]) {        
        [self processMasterLocationDescrSelectionPopover];
        return;
    }
    [self processDescrSelectionPopover];
}

-(void)processMasterLocationDescrSelectionPopover {
    self.headQuarterTitle = @"Head Quarter";
    if (self.masterLocationDisplayList != nil) {            
        [self processDescrSelectionCenter:self.headQuarterTitle dataList:self.masterLocationDisplayList];
        return;
    }
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.superview] autorelease];
    }    
    NSString* sqlStatement = @"select iur,Name,ImageIUR from Location where headoffice = 1 and Active = 1";
    [self.callGenericServices genericGetData:sqlStatement action:@selector(setMasterLocationGetDataResult:) target:self];
}

- (void)setMasterLocationGetDataResult:(ArcosGenericReturnObject*) result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.masterLocationDisplayList = [NSMutableArray array];
        for (int i = 0; i < [result.ArrayOfData count]; i++) {
            ArcosGenericClass* tmpArcosGenericClass = [result.ArrayOfData objectAtIndex:i];
            NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [tmpDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:tmpArcosGenericClass.Field1]]]] forKey:@"DescrDetailIUR"];
            [tmpDict setObject:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:tmpArcosGenericClass.Field2]] forKey:@"Title"];
            [tmpDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:tmpArcosGenericClass.Field3]]]] forKey:@"ImageIUR"];
            [self.masterLocationDisplayList addObject:tmpDict];
        }
        [self processDescrSelectionCenter:self.headQuarterTitle dataList:self.masterLocationDisplayList];
    } else if(result.ErrorModel.Code <= 0) {        
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

-(void)processDescrSelectionPopover {
    NSString* descrTypeCode = [self.cellData objectForKey:@"descrTypeCode"];
    NSMutableArray* dataList = nil;
    NSString* navigationBarTitle = nil;
    
    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:descrTypeCode];  
    navigationBarTitle = [[[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode] objectForKey:@"Details"];
    [self processDescrSelectionCenter:navigationBarTitle dataList:dataList];    
}

-(void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateTableWidgetWithData:aDataList withTitle:aNavBarTitle withParentContentString:[self.cellData objectForKey:@"contentString"]];
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    [self.cellData setObject:[data objectForKey:@"Title"] forKey:@"contentString"];
    [self.cellData setObject:[data objectForKey:@"DescrDetailIUR"] forKey:@"actualContent"];
    self.contentString.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] actualData:[data objectForKey:@"DescrDetailIUR"] forIndexpath:self.indexPath];
}

-(void)dismissPopoverController {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
}

@end
