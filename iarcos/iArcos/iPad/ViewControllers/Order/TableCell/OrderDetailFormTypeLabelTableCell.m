//
//  OrderDetailFormTypeLabelTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 18/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "OrderDetailFormTypeLabelTableCell.h"

@implementation OrderDetailFormTypeLabelTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize widgetFactory = _widgetFactory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.globalWidgetViewController = nil;
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    NSMutableDictionary* tmpDataDict = [theData objectForKey:@"FieldData"];
    self.fieldValueLabel.text = [tmpDataDict objectForKey:@"Details"];
    if (self.isNotEditable) {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blueColor];
    }
    for (UIGestureRecognizer* recognizer in self.fieldValueLabel.gestureRecognizers) {
        [self.fieldValueLabel removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.fieldValueLabel addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateEnded) return;
    if (self.isNotEditable) return;
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    NSMutableArray* auxFormDetailDictList = [[ArcosCoreData sharedArcosCoreData] formDetailWithoutAll];
    NSMutableArray* formDetailDictList = [NSMutableArray arrayWithCapacity:[auxFormDetailDictList count]];
    for (int i = 0; i < [auxFormDetailDictList count]; i++) {
        NSDictionary* auxFormDetailDict = [auxFormDetailDictList objectAtIndex:i];
        NSMutableDictionary* formDetailDict = [NSMutableDictionary dictionaryWithDictionary:auxFormDetailDict];
        [formDetailDict setObject:[ArcosUtils convertNilToEmpty:[formDetailDict objectForKey:@"Details"]] forKey:@"Title"];
        [formDetailDictList addObject:formDetailDict];
    }
    self.globalWidgetViewController = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:formDetailDictList title:@"Form Type"];
//    [self.thePopover presentPopoverFromRect:self.fieldValueLabel.bounds inView:self.fieldValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.fieldValueLabel;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = self.fieldValueLabel.bounds;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [[self.delegate retrieveParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

-(void)operationDone:(id)data {
//    [self.thePopover dismissPopoverAnimated:YES];
    [[self.delegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.fieldValueLabel.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
