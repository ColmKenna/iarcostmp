//
//  DetailingSampleTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingSampleTableCell.h"

@interface DetailingSampleTableCell(Private)
-(void)showPopupWithLabel:(UILabel*)aLabel;

@end

@implementation DetailingSampleTableCell
@synthesize label;
@synthesize qantity;
@synthesize batch;
@synthesize factory;
@synthesize thePopover = _thePopover;

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
    
    NSMutableDictionary* SAData=[theData objectForKey:@"data"];
    if ([SAData objectForKey:@"Qty"]!=nil) {//any given value setted
        NSMutableDictionary* given=[SAData objectForKey:@"Qty"];
        self.qantity.text= [[given objectForKey:@"Qty"]stringValue];
        
        if ([[given objectForKey:@"Qty"]intValue]>0) {
            [self.qantity setTextColor:[UIColor redColor]];
        }else{
            [self.qantity setTextColor:[UIColor blueColor]];
        }
        
    }else{
        self.qantity.text=@"0";
        [self.batch setTextColor:[UIColor blueColor]];
        
    }
    if ([SAData objectForKey:@"Batch"]!=nil) {//any request value setted
        NSMutableDictionary* theBatch=[SAData objectForKey:@"Batch"];
        self.batch.text= [theBatch objectForKey:@"Value"];
        [self.batch setTextColor:[UIColor redColor]];
    }else{
        self.batch.text=@"Select batch";
        [self.batch setTextColor:[UIColor blueColor]];
    }
    
    //add taps action
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.qantity addGestureRecognizer:singleTap];
    [singleTap release];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.batch addGestureRecognizer:singleTap1];
    [singleTap1 release];
}
-(void)handleSingleTapGesture:(id)sender{
    if (!self.isEditable) {//if it not editable then return
        return;
    }
    
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    UILabel* aLabel=(UILabel*)reconizer.view;
    [self showPopupWithLabel:aLabel];
}
-(void)showPopupWithLabel:(UILabel*)aLabel{
    currentLabelIndex=aLabel.tag;
    
    [self.delegate editStartForIndexpath:self.indexPath];
    
//    NSLog(@"single tap is found on %d",aLabel.tag);
    if (self.factory==nil) {
        self.factory=[WidgetFactory factory];
        self.factory.delegate=self;
    }
    
    if (aLabel.tag==0) {
        self.thePopover=[self.factory CreateDetaillingInputPadWidgetWithProductName:self.label.text WithQty:[NSNumber numberWithInt:[self.qantity.text intValue]]];
    }
    if (aLabel.tag==1) {
        self.factory.tempData=[self.cellData objectForKey:@"IUR"];
        self.thePopover=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceDetaillingBatch];
//        NSLog(@"IUR touched %d to look for batche",(NSInteger) self.factory.tempData);
    }
    
    //[self showWidget];
    //popover is shown
    if (self.thePopover!=nil) {
        [self.delegate popoverShows:self.thePopover];
    }
    
    //do show the popover if there is no data
    if (self.thePopover!=nil) {
        self.thePopover.delegate=self;
        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}
#pragma mark widget factory delegate
-(void)operationDone:(id)data{
//    NSLog(@"pad input the data %@",data);
    if (self.thePopover!=nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    
    NSMutableDictionary* SAData=[self.cellData objectForKey:@"data"];
    if (SAData==nil) {
        SAData=[NSMutableDictionary dictionary];
    }
    
    if (currentLabelIndex==0) {
        NSNumber* qty=[data objectForKey:@"Qty"];
        self.qantity.text=[qty stringValue];
        [SAData setObject:data forKey:@"Qty"];
        
        //highlight the number
        if ([qty intValue]>0) {
            [self.qantity setTextColor:[UIColor redColor]];
        }else{
            [self.qantity setTextColor:[UIColor blueColor]];
        }
        
        //invok batch selection  
        NSMutableDictionary* batchData= [SAData objectForKey:@"Batch"];
        if (batchData==nil) {//check any batch selected
            [self.delegate inputFinishedWithData:SAData forIndexpath:self.indexPath];
            self.thePopover = nil;
            self.factory.popoverController = nil;
            [self showPopupWithLabel:self.batch];
            return;
        }
    }
    if (currentLabelIndex==1) {
        NSString* value=[data objectForKey:@"Value"];
        self.batch.text=value ;
        [SAData setObject:data forKey:@"Batch"];
        
        //highlight the number
        if (![value isEqualToString:@"Select batch"]) {
            [self.batch setTextColor:[UIColor redColor]];
        }else{
            [self.batch setTextColor:[UIColor blueColor]];
        }
        
    }
    
//    NSLog(@"detailing cell data is %@",self.cellData);
    
    //send the data back (bad fit)
    [self.delegate inputFinishedWithData:SAData forIndexpath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.qantity != nil) { self.qantity = nil; }
    if (self.batch != nil) { self.batch = nil; }
    if (self.factory != nil) { self.factory = nil; }
    self.thePopover = nil;
            
    [super dealloc];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
