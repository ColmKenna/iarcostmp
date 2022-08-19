//
//  PackageTableViewCell.m
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "PackageTableViewCell.h"

@implementation PackageTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize myImageView = _myImageView;
@synthesize packageDesc = _packageDesc;
@synthesize accountCode = _accountCode;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    self.myImageView = nil;
    self.packageDesc = nil;
    self.accountCode = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aData {
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
    NSMutableDictionary* wholesalerIurImageIurHashMap = [self.actionDelegate retrieveWholesalerIurImageIurHashMap];
    NSMutableDictionary* pGiurDetailHashMap = [self.actionDelegate retrievePGiurDetailHashMap];
    NSNumber* tmpWholesalerIur = [aData objectForKey:@"wholesalerIUR"];
    NSNumber* tmpImageIur = [wholesalerIurImageIurHashMap objectForKey:tmpWholesalerIur];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([tmpImageIur intValue] > 0) {
        anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:tmpImageIur];
    } else {
        anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:1]];
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    self.myImageView.image = anImage;
    if (isCompanyImage) {
        self.myImageView.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        self.myImageView.alpha = 1.0;
    }
    
    NSNumber* tmpPGiur = [aData objectForKey:@"pGiur"];
    NSString* tmpDetail = [pGiurDetailHashMap objectForKey:tmpPGiur];
    self.packageDesc.text = [ArcosUtils convertNilToEmpty:tmpDetail];
    self.accountCode.text = [ArcosUtils convertNilToEmpty:[aData objectForKey:@"accountCode"]];
    NSNumber* selectedFlag = [aData objectForKey:@"selectedFlag"];
    if ([selectedFlag intValue] == 1) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate rowPressedWithIndexPath:self.myIndexPath];
    }
}

@end
