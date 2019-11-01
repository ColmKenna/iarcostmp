//
//  CustomerSurveySignatureTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 31/10/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySignatureTableCell.h"
#import "ArcosUtils.h"

@implementation CustomerSurveySignatureTableCell
@synthesize drawingAreaView = _drawingAreaView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.drawingAreaView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.drawingAreaView.dataDelegate = self;
    self.narrative.text = [theData objectForKey:@"Narrative"];
    [self processIndicatorButton];
    NSString* aResponse = [theData objectForKey:@"Answer"];
    NSMutableArray* resultList = [NSMutableArray array];
    if (aResponse != nil && ![aResponse isEqualToString:@""] && ![aResponse isEqualToString:[GlobalSharedClass shared].unknownText]) {
        NSArray* lineList = [aResponse componentsSeparatedByString:@";"];
        for (int i = 0; i < [lineList count]; i++) {
            NSString* aLine = [lineList objectAtIndex:i];
            NSArray* pointList = [aLine componentsSeparatedByString:@","];
            if ([pointList count] > 3) {
                ArcosLineSegment* arcosLineSegment = [[ArcosLineSegment alloc] init:CGPointMake([[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:0]] floatValue], [[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:1]] floatValue]) withEnd:CGPointMake([[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:2]] floatValue], [[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:3]] floatValue])];
                [resultList addObject:arcosLineSegment];
                [arcosLineSegment release];
            }
        }
    }
    [self.drawingAreaView loadData:resultList];
    [self configNarrativeSingleTapGesture];
    [self configNarrativeWithLabel:self.narrative];
}

- (void)touchBeganWithAction {
    [self.delegate retrieveSurveyTableView].scrollEnabled = NO;
}

- (void)touchEndedWithData:(NSMutableArray *)aDataList {
    NSString* signatureString = @"";
    NSMutableArray* signatureList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosLineSegment* arcosLineSegment = [aDataList objectAtIndex:i];
        [signatureList addObject:[NSString stringWithFormat:@"%1.1f,%1.1f,%1.1f,%1.1f", arcosLineSegment.start.x, arcosLineSegment.start.y, arcosLineSegment.end.x, arcosLineSegment.end.y]];
    }
    signatureString = [signatureList componentsJoinedByString:@";"];
    [self.delegate inputFinishedWithData:signatureString forIndexpath:self.indexPath];
    [self.delegate retrieveSurveyTableView].scrollEnabled = YES;
}

@end
