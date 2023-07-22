//
//  DetailingGivenRequestTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingGivenRequestTableCell.h"


@implementation DetailingGivenRequestTableCell
@synthesize label;
@synthesize givenQantity;
@synthesize requestQantity;
@synthesize factory;
@synthesize thePopover = _thePopover;
@synthesize givenTitle;
@synthesize requestTitle;
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
    self.label.text=[theData objectForKey:@"Label"];
    self.cellData=theData;
    
    NSMutableDictionary* GRData=[theData objectForKey:@"data"];
    
    //given
    if ([GRData objectForKey:@"Given"]!=nil) {//any given value setted
        NSMutableDictionary* given=[GRData objectForKey:@"Given"];
        self.givenQantity.text= [[given objectForKey:@"Qty"]stringValue];
        
        if ([[given objectForKey:@"Qty"]intValue]>0) {
            [self.givenQantity setTextColor:[UIColor redColor]];
        }else{
            [self.givenQantity setTextColor:[UIColor blueColor]];
        }
    }else{
        self.givenQantity.text=@"0";
        [self.givenQantity setTextColor:[UIColor blueColor]];
    }
    
    //request
    if ([GRData objectForKey:@"Request"]!=nil) {//any request value setted
        NSMutableDictionary* request=[GRData objectForKey:@"Request"];
        self.requestQantity.text=[[request objectForKey:@"Qty"]stringValue];
        
        if ([[request objectForKey:@"Qty"]intValue]>0) {
            [self.requestQantity setTextColor:[UIColor redColor]];
        }else{
            [self.requestQantity setTextColor:[UIColor blueColor]];
        }

    }else{
        self.requestQantity.text=@"0";
        [self.requestQantity setTextColor:[UIColor blueColor]];
    }
    [self suppressZeroForGivenRequest];
    
    //add taps action
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.givenQantity addGestureRecognizer:singleTap];
    [singleTap release];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.requestQantity addGestureRecognizer:singleTap1];
    [singleTap1 release];
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
    
    if (aLabel.tag==0) {
        self.thePopover=[self.factory CreateDetaillingInputPadWidgetWithProductName:self.label.text WithQty:[NSNumber numberWithInt:[[ArcosUtils convertBlankToZero:self.givenQantity.text] intValue]]];
    }
    if (aLabel.tag==1) {
        self.thePopover=[self.factory CreateDetaillingInputPadWidgetWithProductName:self.label.text WithQty:[NSNumber numberWithInt:[[ArcosUtils convertBlankToZero:self.requestQantity.text] intValue]]];
    }

    //[self showWidget];
    //popover is shown
    if (self.thePopover!=nil) {
        [self.delegate popoverShows:self.thePopover];
    }
    
    //do show the popover if there is no data
    if (self.thePopover!=nil) {
        self.thePopover.delegate=self;
        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    
    
}
#pragma mark widget factory delegate
-(void)operationDone:(id)data{
//    NSLog(@"pad input the data %@",data);
    if (self.thePopover!=nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    
    NSMutableDictionary* GRData=[self.cellData objectForKey:@"data"];
    if (GRData==nil) {
        GRData=[NSMutableDictionary dictionary];
    }
    
    if (currentLabelIndex==0) {
        [data setObject:@"GV" forKey:@"DetailLevel"];
        NSNumber* qty=[data objectForKey:@"Qty"];
        self.givenQantity.text=[qty stringValue];
        [GRData setObject:data forKey:@"Given"];
        
        //highlight the number
        if ([qty intValue]>0) {
            [self.givenQantity setTextColor:[UIColor redColor]];
        }else{
            [self.givenQantity setTextColor:[UIColor blueColor]];
        }
    }
    if (currentLabelIndex==1) {
        [data setObject:@"RQ" forKey:@"DetailLevel"];
        NSNumber* qty=[data objectForKey:@"Qty"];
        self.requestQantity.text=[qty stringValue];
        [GRData setObject:data forKey:@"Request"];

        //highlight the number
        if ([qty intValue]>0) {
            [self.requestQantity setTextColor:[UIColor redColor]];
        }else{
            [self.requestQantity setTextColor:[UIColor blueColor]];
        }
            
    }
    [self suppressZeroForGivenRequest];
    
    
//    NSLog(@"detailing cell data is %@",self.cellData);
    
    //send the data back (bad fit)
    [self.delegate inputFinishedWithData:GRData forIndexpath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.givenQantity != nil) { self.givenQantity = nil; } 
    if (self.requestQantity != nil) { self.requestQantity = nil; }
    if (self.factory != nil) { self.factory = nil; }
    self.thePopover = nil;
    self.givenTitle = nil;
    self.requestTitle = nil;
    
    [super dealloc];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

- (void)suppressZeroForGivenRequest {
    if ([self.givenQantity.text isEqualToString:@"0"]) {
        self.givenQantity.text = @"";
    }
    if ([self.requestQantity.text isEqualToString:@"0"]) {
        self.requestQantity.text = @"";
    }
}

@end
