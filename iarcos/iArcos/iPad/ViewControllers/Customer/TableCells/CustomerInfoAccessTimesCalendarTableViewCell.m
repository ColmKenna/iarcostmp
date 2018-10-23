//
//  CustomerInfoAccessTimesCalendarTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarTableViewCell.h"

@implementation CustomerInfoAccessTimesCalendarTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize timeLabel = _timeLabel;
@synthesize sunLabel = _sunLabel;
@synthesize monLabel = _monLabel;
@synthesize tueLabel = _tueLabel;
@synthesize wedLabel = _wedLabel;
@synthesize thuLabel = _thuLabel;
@synthesize friLabel = _friLabel;
@synthesize satLabel = _satLabel;
@synthesize labelList = _labelList;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.timeLabel = nil;
    self.sunLabel = nil;
    self.monLabel = nil;
    self.tueLabel = nil;
    self.wedLabel = nil;
    self.thuLabel = nil;
    self.friLabel = nil;
    self.satLabel = nil;
    self.labelList = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aGroupData sectionData:(NSMutableDictionary*)aSectionData {
    self.labelList = [NSMutableArray arrayWithObjects:self.sunLabel, self.monLabel, self.tueLabel, self.wedLabel, self.thuLabel, self.friLabel, self.satLabel, nil];
    self.timeLabel.text = [aSectionData objectForKey:@"Time"];
    NSMutableArray* auxDisplayList = [aGroupData objectForKey:[aSectionData objectForKey:@"AccessTime"]];
    for (int i = 0; i < [self.labelList count]; i++) {
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        NSNumber* colorType = [auxDisplayList objectAtIndex:i];
        switch ([colorType intValue]) {
            case 0:
                tmpLabel.backgroundColor = [UIColor whiteColor];
                break;
            case 1:
                tmpLabel.backgroundColor = [UIColor greenColor];
                break;
            case 2:
                tmpLabel.backgroundColor = [UIColor blackColor];
                break;
                
            default:
                tmpLabel.backgroundColor = [UIColor whiteColor];
                break;
        }
    }
    for (UILabel* auxLabel in self.labelList) {
        for (UIGestureRecognizer* recognizer in auxLabel.gestureRecognizers) {
            [auxLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [auxLabel addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [auxLabel addGestureRecognizer:singleTap];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPress.minimumPressDuration = 1.0;
        [auxLabel addGestureRecognizer:longPress];
        
        [longPress release];
        [doubleTap release];
        [singleTap release];
    }
    
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender {
    UILabel* tapLabel = (UILabel*)sender.view;
    tapLabel.backgroundColor = [UIColor blackColor];
    [self.actionDelegate inputFinishedWithIndexPath:self.indexPath labelIndex:[ArcosUtils convertNSIntegerToInt:tapLabel.tag] colorType:[NSNumber numberWithInt:2]];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    UILabel* tapLabel = (UILabel*)sender.view;
    [self.actionDelegate inputFinishedWithIndexPath:self.indexPath labelIndex:[ArcosUtils convertNSIntegerToInt:tapLabel.tag] colorType:[NSNumber numberWithInt:1]];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UILabel* tapLabel = (UILabel*)sender.view;
        [self.actionDelegate inputFinishedWithIndexPath:self.indexPath labelIndex:[ArcosUtils convertNSIntegerToInt:tapLabel.tag] colorType:[NSNumber numberWithInt:0]];
    }
}


@end
