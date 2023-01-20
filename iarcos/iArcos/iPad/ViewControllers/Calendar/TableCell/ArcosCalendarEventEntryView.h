//
//  ArcosCalendarEventEntryView.h
//  iArcos
//
//  Created by Richard on 19/01/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ArcosCalendarEventEntryView : UIView {
    UILabel* _mainContentLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* mainContentLabel;

@end


