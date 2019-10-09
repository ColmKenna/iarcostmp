//
//  CustomerSurveyTableMSTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 30/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyTableMSTableCell.h"

@implementation CustomerSurveyTableMSTableCell
//@synthesize narrative;
@synthesize responseLimits;
@synthesize factory;
@synthesize thePopover = _thePopover;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self processIndicatorButton];
    self.narrative.text = [theData objectForKey:@"Narrative"];
    NSString* aResponse = [theData objectForKey:@"Answer"];
    if (aResponse != nil && ![aResponse isEqualToString:@""]) {
        self.responseLimits.text = aResponse;
    } else {
        self.responseLimits.text = @"Touch to pick a value";
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.responseLimits addGestureRecognizer:singleTap];
    [singleTap release];
//    for (UIGestureRecognizer* recognizer in self.narrative.gestureRecognizers) {
//        [self.narrative removeGestureRecognizer:recognizer];
//    }
//    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
//    [self.narrative addGestureRecognizer:singleTap2];
//    [singleTap2 release];
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
}

-(void)handleSingleTapGesture:(id)sender {
    NSString* responseLimitsDataSource = [self.cellData objectForKey:@"ResponseLimits"];
    NSArray* responseLimitsArray = [responseLimitsDataSource componentsSeparatedByString:@"|"];
    NSMutableArray* pickerData = [NSMutableArray array];
    for (int i = 0; i < [responseLimitsArray count]; i++) {
        NSMutableDictionary* responseLimitDict = [NSMutableDictionary dictionary];
        [responseLimitDict setObject:[responseLimitsArray objectAtIndex:i] forKey:@"Title"];
        [responseLimitDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        [pickerData addObject:responseLimitDict];
    }
    NSMutableDictionary* unknownResponseLimitDict = [NSMutableDictionary dictionary];
    [unknownResponseLimitDict setObject:[GlobalSharedClass shared].unknownText forKey:@"Title"];
    [unknownResponseLimitDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    [pickerData insertObject:unknownResponseLimitDict atIndex:0];
    NSArray* tmpParentItemList = [self.responseLimits.text componentsSeparatedByString:@"|"];
    NSMutableArray* parentItemList = [NSMutableArray arrayWithArray:tmpParentItemList];
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateTableMSWidgetWithData:pickerData withTitle:@"ResponseLimits" withParentItemList:parentItemList requestSource:TableMSWidgetRequestSourceDefault];
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.responseLimits.bounds inView:self.responseLimits permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    self.responseLimits.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] forIndexpath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

-(void)dealloc {
//    if (self.narrative != nil) { self.narrative = nil; }
    if (self.responseLimits != nil) { self.responseLimits = nil; }
    if (self.factory != nil) { self.factory = nil; }
    self.thePopover = nil;
    
    [super dealloc];
}

//-(void)handleSingleTapGesture4Narrative:(id)sender {
//    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
//}

-(void)dismissPopoverController {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.thePopover = nil;
        self.factory.popoverController = nil;
    }
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
