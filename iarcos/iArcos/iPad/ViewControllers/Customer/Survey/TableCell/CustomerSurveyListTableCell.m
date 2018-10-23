//
//  CustomerSurveyListTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyListTableCell.h"

@implementation CustomerSurveyListTableCell
@synthesize narrative;
@synthesize surveyTitle;
@synthesize factory = _factory;
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
    self.cellData = theData;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.surveyTitle addGestureRecognizer:singleTap];
    [singleTap release];
//    NSLog(@"surveyTitle is : %@", [theData objectForKey:@"Title"]);
//    NSLog(@"surveyTitle %@", theData);
//    self.surveyTitle = [theData objectForKey:@"Title"];
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture4Narrative:)];
    [self.narrative addGestureRecognizer:singleTap2];
    [singleTap2 release];    
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    
    self.thePopover = [self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourceCustomerSurvey];
    if (self.thePopover != nil) {
        //        [self.delegate popoverShows:thePopover];
    }else{
        self.surveyTitle.text = @"No Active Surveys";
    }
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:surveyTitle.bounds inView:surveyTitle permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    self.surveyTitle.text = [data objectForKey:@"Title"];
//    NSLog(@"StartDate is %@", [data objectForKey:@"StartDate"]);
//    NSLog(@"EndDate is %@", [data objectForKey:@"EndDate"]);
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

-(void)handleSingleTapGesture4Narrative:(id)sender {
    [self.delegate showSurveyDetail];    
}

- (void)dealloc
{
    if (self.narrative != nil) {
        self.narrative = nil;
    }
    if (self.surveyTitle != nil) { self.surveyTitle = nil; }
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
