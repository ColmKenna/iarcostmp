//
//  CustomerContactTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 29/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactTableCell.h"

@implementation CustomerContactTableCell
@synthesize contentString;
@synthesize factory = _factory;

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
    [super dealloc];
}

-(IBAction)textInputEnd:(id)sender {
    UITextField* tf = (UITextField*)sender;
    if (self.cellData == nil) {
        self.cellData = [NSMutableDictionary dictionary];
    }
    [self.cellData setObject:tf.text forKey:@"contentString"];
    [self.cellData setObject:tf.text forKey:@"actualContent"];
    
    [self.delegate inputFinishedWithData:tf.text actualContent:tf.text WithIndexPath:self.indexPath];
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    
    NSMutableArray* dataList = nil;
    NSString* navigationBarTitle = @"";
    NSString* settingType = @"";
    
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    UITextField* aTextField = (UITextField*)recognizer.view;
    switch (aTextField.tag) {
        case 0: {
            settingType = @"CL";
        }            
            break;
        case 6: {
            settingType = @"CO";
        }
            break;
        default:
            break;
    }
    dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:settingType];  
    navigationBarTitle = [[[ArcosCoreData sharedArcosCoreData] descrTypeWithTypeCode:settingType] objectForKey:@"Details"];
    
    thePopover = [self.factory CreateTableWidgetWithData:dataList withTitle:navigationBarTitle withParentContentString:[self.cellData objectForKey:@"contentString"]];
    //do show the popover if there is no data
    if (thePopover != nil) {
        thePopover.delegate = self;
        [thePopover presentPopoverFromRect:self.contentString.bounds inView:self.contentString permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
-(void)operationDone:(id)data {
    if (thePopover != nil) {
        [thePopover dismissPopoverAnimated:YES];
    }
    if (self.cellData == nil) {
        self.cellData = [NSMutableDictionary dictionary];
    }
    [self.cellData setObject:[data objectForKey:@"Title"] forKey:@"contentString"];
    [self.cellData setObject:[data objectForKey:@"DescrDetailIUR"] forKey:@"actualContent"];
    self.contentString.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] actualContent:[data objectForKey:@"DescrDetailIUR"] WithIndexPath:self.indexPath];
}
-(void)dismissPopoverController {
    if (thePopover != nil) {
        [thePopover dismissPopoverAnimated:YES];
    }
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.contentString.text = [theData objectForKey:@"contentString"];
    
    switch (self.contentString.tag) {
        case 0: {
            self.contentString.inputView = [[[UIView alloc] init] autorelease];
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
            [self.contentString addGestureRecognizer:singleTap];
            [singleTap release];
        }            
            break;
        case 1:
        case 2: {
            self.contentString.keyboardType = UIKeyboardTypeDefault;
        }            
            break;
        case 3:
        case 4: {
            self.contentString.keyboardType = UIKeyboardTypePhonePad;
        }            
            break;
        case 5: {
            self.contentString.keyboardType = UIKeyboardTypeEmailAddress;
        }            
            break;
        case 6: {
            self.contentString.inputView = [[[UIView alloc] init] autorelease];
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
            [self.contentString addGestureRecognizer:singleTap];
            [singleTap release];
        }            
            break;
            
        default:
            break;
    }
}

@end
