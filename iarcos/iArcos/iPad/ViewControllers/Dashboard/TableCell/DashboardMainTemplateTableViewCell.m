//
//  DashboardMainTemplateTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateTableViewCell.h"

@implementation DashboardMainTemplateTableViewCell
@synthesize cellDelegate = _cellDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableArray*)aDictList {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < [aDictList count]; i++) {
        DashboardMainTemplateDataObject* dashboardMainTemplateDataObject = [aDictList objectAtIndex:i];
        CGRect btnRect = CGRectMake(dashboardMainTemplateDataObject.xPos, dashboardMainTemplateDataObject.yPos, dashboardMainTemplateDataObject.width, dashboardMainTemplateDataObject.height);
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;        
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            btnRect = CGRectMake(dashboardMainTemplateDataObject.xPos * 0.73, dashboardMainTemplateDataObject.yPos, dashboardMainTemplateDataObject.width * 0.73, dashboardMainTemplateDataObject.height);
        }
//        ArcosBorderUIButton* auxBtn = [[ArcosBorderUIButton alloc] initWithFrame:btnRect];
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardMainTemplateTableViewButton" owner:self options:nil];
        DashboardMainTemplateBaseButton* auxBtn = nil;
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardMainTemplateBaseButton class]]) {
                DashboardMainTemplateBaseButton* tmpBtn = (DashboardMainTemplateBaseButton*)nibItem;
                if (tmpBtn.tag == dashboardMainTemplateDataObject.buttonType) {
                    auxBtn = tmpBtn;
                }
            }
        }
        auxBtn.frame = btnRect;
        auxBtn.dashboardMainTemplateDataObject = dashboardMainTemplateDataObject;
        [auxBtn configButtonWithData:dashboardMainTemplateDataObject];
//        auxBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];        
        [auxBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [auxBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self.contentView addSubview:auxBtn];
    }
}

- (void)btnPressed:(DashboardMainTemplateBaseButton*)aBtn {
    NSLog(@"a pressed");
    [self.cellDelegate dashboardBoxPressedWithIUR:aBtn.dashboardMainTemplateDataObject.IUR];
}

- (void)dealloc {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [super dealloc];
}

@end
