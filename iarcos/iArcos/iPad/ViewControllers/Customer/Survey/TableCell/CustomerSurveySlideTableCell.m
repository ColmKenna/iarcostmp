//
//  CustomerSurveySlideTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySlideTableCell.h"

@implementation CustomerSurveySlideTableCell
//@synthesize narrative;
@synthesize responseLimits;
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

- (void)dealloc {
//    if (self.narrative != nil) { self.narrative = nil; }
    if (self.responseLimits != nil) { self.responseLimits = nil; }
    if (self.factory != nil) { self.factory = nil; }
    self.thePopover = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    [self processIndicatorButton];
    self.narrative.text = [theData objectForKey:@"Narrative"];    
    NSString* anAnswer = [theData objectForKey:@"Answer"];
    if (anAnswer != nil && ![anAnswer isEqualToString:@""]) {
        self.responseLimits.text = anAnswer;
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
    NSMutableArray* tableDataList = [NSMutableArray array];
    for (int i = 0; i < [responseLimitsArray count]; i++) {
        NSMutableDictionary* responseLimitDict = [NSMutableDictionary dictionary];
        [responseLimitDict setObject:[responseLimitsArray objectAtIndex:i] forKey:@"Title"];
        [tableDataList addObject:responseLimitDict];
    }
    NSMutableDictionary* unknownResponseLimitDict = [NSMutableDictionary dictionary];
    [unknownResponseLimitDict setObject:[GlobalSharedClass shared].unknownText forKey:@"Title"];
    [tableDataList insertObject:unknownResponseLimitDict atIndex:0];
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateTableWidgetWithData:tableDataList withTitle:@"ResponseLimits" withParentContentString:self.responseLimits.text];
    
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

-(void)dismissPopoverController {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.thePopover = nil;
        self.factory.popoverController = nil;
    }
}

//-(void)handleSingleTapGesture4Narrative:(id)sender {
//    [ArcosUtils showMsg:[self.cellData objectForKey:@"tooltip"] delegate:nil];
//}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}
@end
