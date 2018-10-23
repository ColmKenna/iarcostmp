//
//  CustomerSurveyDetailsResponseWheelTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 29/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsResponseWheelTableCell.h"

@implementation CustomerSurveyDetailsResponseWheelTableCell
@synthesize narrative = _narrative;
@synthesize response = _response;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.narrative = nil;
    self.response = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.cellData = aCellData;
    self.narrative.text = aCellData.Field4;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.response addGestureRecognizer:singleTap];
    [singleTap release];
    
    self.response.text = aCellData.Field6;
    if ([[ArcosUtils convertStringToNumber:[ArcosUtils trim:aCellData.Field7]] intValue] == 0) {        
        self.response.userInteractionEnabled = NO;
    } else {
        self.response.userInteractionEnabled = YES;
    } 
}

-(void)handleSingleTapGesture:(id)sender {
    NSString* responseLimitsDataSource = self.cellData.Field5;
    NSArray* responseLimitsArray = [responseLimitsDataSource componentsSeparatedByString:@"|"];
    NSMutableArray* pickerData = [NSMutableArray array];
    for (int i = 0; i < [responseLimitsArray count]; i++) {
        NSMutableDictionary* responseLimitDict = [NSMutableDictionary dictionary];
        [responseLimitDict setObject:[responseLimitsArray objectAtIndex:i] forKey:@"Title"];
        [pickerData addObject:responseLimitDict];
    }    
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateGenericCategoryWidgetWithPickerValue:pickerData title:@"ResponseLimits"];
    
    //do show the popover if there is no data
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.response.bounds inView:self.response permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    self.response.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:[data objectForKey:@"Title"] forIndexPath:self.indexPath];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

@end
