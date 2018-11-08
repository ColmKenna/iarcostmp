//
//  MeetingMainBaseSectionView.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingMainBaseSectionView : UIView {
    UILabel* _sectionTitleLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* sectionTitleLabel;

- (void)configSectionViewWithData:(NSMutableDictionary*)aViewData;

@end

