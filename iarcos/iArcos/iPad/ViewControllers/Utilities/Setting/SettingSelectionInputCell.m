//
//  SettingSelectionInputCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingSelectionInputCell.h"


@implementation SettingSelectionInputCell
@synthesize label;
@synthesize statusLabel;
@synthesize factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
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
-(void)valueChange:(id)data{
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData=theData;
    self.label.text=[theData objectForKey:@"Label"];
    
    if ([[theData objectForKey:@"Value"]intValue]<=0) {
        self.statusLabel.text=@"Touch to select a default status";
    }else{
        //get the status string from the coredata
        NSNumber* descIUR=[theData objectForKey:@"Value"];
        NSDictionary* aDesc=nil;
        
        if (self.indexPath.row==7) {//form fit
            aDesc=[[ArcosCoreData sharedArcosCoreData]formWithIUR:descIUR];
        }else{
            aDesc=[[ArcosCoreData sharedArcosCoreData]descriptionWithIURActive:descIUR];
        }
        
        NSString* descDetail=[aDesc objectForKey:@"Detail"];
        
        if (descDetail==nil||[descDetail isEqualToString:@""]) {
            descDetail=@"Undefined";
        }
        self.statusLabel.text=descDetail;

    }
    
    //add taps action
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}
//show widget
-(void)showWidget{
    //facotry testing
//    UIPopoverController* popover;
    
        switch (self.indexPath.row) {
            case 0:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceLocationType];
                break;
            case 1:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceContactType];
                
                break;
            case 2:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
                
                break;
            case 3:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus];
                
                break;
            case 4:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderType];
                
                break;
            case 5:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus];
                break;
            case 6:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceLocationType];
                break;
            case 7:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceFormType];
                break;
            case 8:
                self.globalWidgetViewController=[self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceMemoType];
                break;
            default:
                break;
        }
        //do show the popover if there is no data
//        self.thePopover=popover;
        if (self.globalWidgetViewController!=nil) {
//            self.thePopover.delegate=self;
//            [self.thePopover presentPopoverFromRect:self.statusLabel.bounds inView:self.statusLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
            self.globalWidgetViewController.popoverPresentationController.sourceView = self.statusLabel;
            self.globalWidgetViewController.popoverPresentationController.sourceRect = self.statusLabel.bounds;
            self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.globalWidgetViewController.popoverPresentationController.delegate = self;
            [[self.delegate retrieveParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
        }
    
}
-(void)handleSingleTapGesture:(id)sender{
    [self.delegate editStartForIndexpath:self.indexPath];

//    NSLog(@"single tap is found on %@",[self.cellData objectForKey:@"Label"]);
    if (self.factory==nil) {
        self.factory=[WidgetFactory factory];
        self.factory.delegate=self;
    }
    [self showWidget];
    //popover is shown
//    if (self.thePopover!=nil) {
//        [self.delegate popoverShows:self.thePopover];
//    }
}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.statusLabel != nil) { self.statusLabel = nil; } 
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    
    [super dealloc];
}

#pragma mark widget factory delegate
-(void)operationDone:(id)data{
//    NSLog(@"widget pick the data %@",data);
//    if (self.thePopover!=nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    //set the label text  (bad fit)
    NSString* labelText=[(NSMutableDictionary*)data objectForKey:@"Detail"];
//    if (labelText==nil) {
//        labelText=[(NSMutableDictionary*)data objectForKey:@"Name"];
//    }
    self.statusLabel.text=labelText;
    
    //send the data back (bad fit)
    id value=[(NSMutableDictionary*)data objectForKey:@"DescrDetailIUR"];
//    if (value==nil) {
//        value=[(NSMutableDictionary*)data objectForKey:@"LocationIUR"];
//    }
    [self valueChange:value];
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}
@end
