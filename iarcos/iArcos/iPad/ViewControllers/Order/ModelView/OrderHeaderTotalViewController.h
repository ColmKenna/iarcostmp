//
//  OrderHeaderTotalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 18/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"

@interface OrderHeaderTotalViewController : UIViewController {
    IBOutlet UILabel* totalOrders;
    IBOutlet UILabel* totalValue;
    IBOutlet UILabel* totalPoints;
    IBOutlet UILabel* averageValue;
    IBOutlet UILabel* dailyTarget;
    IBOutlet UILabel* weeklyTarget;
    IBOutlet UILabel* monthlyTarget;
    IBOutlet UILabel* yearlyTarget;
    IBOutlet UILabel* dailyPrecentage;
    IBOutlet UILabel* weeklyPrecentage;
    IBOutlet UILabel* monthlyPrecentage;
    IBOutlet UILabel* yearlyPrecentage;
    IBOutlet UILabel* fromDateLabel;
    IBOutlet UILabel* toDateLabel;
    IBOutlet UILabel* dailyLabel;
    IBOutlet UILabel* weeklyLabel;
    IBOutlet UILabel* monthlyLabel;
    IBOutlet UILabel* yearlyLabel;
    IBOutlet UILabel* summaryTypeLabel;
    IBOutlet UIImageView* passImage;
    IBOutlet UILabel* bottomStatement;


    
    id<ModelViewDelegate> delegate;
    
    NSMutableDictionary* theData;
}
@property (nonatomic, retain) id<ModelViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UILabel* totalOrders;
@property(nonatomic,retain) IBOutlet UILabel* totalValue;
@property(nonatomic,retain) IBOutlet UILabel* totalPoints;
@property(nonatomic,retain) IBOutlet UILabel* averageValue;
@property(nonatomic,retain) IBOutlet UILabel* dailyTarget;
@property(nonatomic,retain) IBOutlet UILabel* weeklyTarget;
@property(nonatomic,retain) IBOutlet UILabel* monthlyTarget;
@property(nonatomic,retain) IBOutlet UILabel* yearlyTarget;
@property(nonatomic,retain) IBOutlet UILabel* dailyPrecentage;
@property(nonatomic,retain) IBOutlet UILabel* weeklyPrecentage;
@property(nonatomic,retain) IBOutlet UILabel* monthlyPrecentage;
@property(nonatomic,retain) IBOutlet UILabel* yearlyPrecentage;
@property(nonatomic,retain) IBOutlet UILabel* fromDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* toDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* dailyLabel;
@property(nonatomic,retain) IBOutlet UILabel* weeklyLabel;
@property(nonatomic,retain) IBOutlet UILabel* monthlyLabel;
@property(nonatomic,retain) IBOutlet UILabel* yearlyLabel;
@property(nonatomic,retain) IBOutlet UILabel* summaryTypeLabel;

@property(nonatomic,retain) NSMutableDictionary* theData;
@property(nonatomic,retain) IBOutlet UIImageView* passImage;
@property(nonatomic,retain) IBOutlet UILabel* bottomStatement;


-(IBAction)donePressed:(id)sender;

@end
