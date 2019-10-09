//
//  CustomerSurveyWheelTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyWheelTableCell.h"

@implementation CustomerSurveyWheelTableCell
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
    self.narrative.frame = CGRectMake(self.narrative.frame.origin.x, self.narrative.frame.origin.y, self.narrative.frame.size.width, 42);
    int questionType = [[self.cellData objectForKey:@"QuestionType"] intValue];
    if (questionType == 3) {
        NSMutableAttributedString* attributedNarrativeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.cellData objectForKey:@"Narrative"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        CGRect rect = [attributedNarrativeString boundingRectWithSize:CGSizeMake([self.delegate retrieveSurveyTableView].frame.size.width - 25, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedNarrativeString release];
        if (rect.size.height < 21.0) {
            rect.size.height = 21.0;
        }
        self.narrative.frame = CGRectMake(self.narrative.frame.origin.x, self.narrative.frame.origin.y, self.narrative.frame.size.width, rect.size.height);
        self.responseLimits.frame = CGRectMake(self.responseLimits.frame.origin.x, rect.size.height + 9, self.responseLimits.frame.size.width, self.responseLimits.frame.size.height);
    }
}

-(void)handleSingleTapGesture:(id)sender {
    NSString* responseLimitsDataSource = [self.cellData objectForKey:@"ResponseLimits"];
    NSArray* responseLimitsArray = [responseLimitsDataSource componentsSeparatedByString:@"|"];
    NSMutableArray* pickerData = [NSMutableArray array];
    int maxTextLength = 0;
    for (int i = 0; i < [responseLimitsArray count]; i++) {
        NSMutableDictionary* responseLimitDict = [NSMutableDictionary dictionary];
        NSString* auxTitle = [responseLimitsArray objectAtIndex:i];
        int auxTitleLength = [ArcosUtils convertNSUIntegerToUnsignedInt:[auxTitle length]];
        if (auxTitleLength > maxTextLength) {
            maxTextLength = auxTitleLength;
        }
        [responseLimitDict setObject:auxTitle forKey:@"Title"];
        [pickerData addObject:responseLimitDict];
    }
    NSMutableDictionary* unknownResponseLimitDict = [NSMutableDictionary dictionary];
    [unknownResponseLimitDict setObject:[GlobalSharedClass shared].unknownText forKey:@"Title"];
    [pickerData insertObject:unknownResponseLimitDict atIndex:0];
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateGenericDynamicCategoryWidgetWithPickerValue:pickerData title:@"ResponseLimits" maxTextLength:maxTextLength];
    if (self.thePopover != nil) {
        //        [self.delegate popoverShows:thePopover];
    }else{
//        self.contactTitle.text = @"No contact found";
    }
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        int times = 1;
        if (maxTextLength <= [GlobalSharedClass shared].popoverMinimumWidth) {
            self.thePopover.popoverContentSize = CGSizeMake(self.thePopover.popoverContentSize.width / 2.0, self.thePopover.popoverContentSize.height);
        } else if (maxTextLength <= [GlobalSharedClass shared].popoverMediumWidth) {
            times = (int)[GlobalSharedClass shared].popoverMediumWidth * 1.0 / [GlobalSharedClass shared].popoverMinimumWidth;
            self.thePopover.popoverContentSize = CGSizeMake(self.thePopover.popoverContentSize.width / 2.0 * times, self.thePopover.popoverContentSize.height);
        } else if(maxTextLength <= [GlobalSharedClass shared].popoverLargeWidth) {
            times = (int)[GlobalSharedClass shared].popoverLargeWidth * 1.0 / [GlobalSharedClass shared].popoverMinimumWidth;
            self.thePopover.popoverContentSize = CGSizeMake(self.thePopover.popoverContentSize.width / 2.0 * times, self.thePopover.popoverContentSize.height);
        } else if (maxTextLength <= [GlobalSharedClass shared].popoverMaximumWidth) {
            times = (int)[GlobalSharedClass shared].popoverMaximumWidth * 1.0 / [GlobalSharedClass shared].popoverMinimumWidth;
            self.thePopover.popoverContentSize = CGSizeMake(self.thePopover.popoverContentSize.width / 2.0 * times, self.thePopover.popoverContentSize.height);
        } else {
            times = (int)[GlobalSharedClass shared].popoverMaximumWidth * 1.0 / [GlobalSharedClass shared].popoverMinimumWidth;
            self.thePopover.popoverContentSize = CGSizeMake(self.thePopover.popoverContentSize.width / 2.0 * times, self.thePopover.popoverContentSize.height);
        }
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

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}
@end
