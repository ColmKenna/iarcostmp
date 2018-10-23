//
//  OrderProductTotalModelViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"


@interface OrderProductTotalModelViewController : UIViewController {
    IBOutlet UILabel* totalProducts;
    IBOutlet UILabel* totalValue;
    IBOutlet UILabel* totalPoints;
    IBOutlet UILabel* totalBonus;
    IBOutlet UILabel* totalQty;

    
    id<ModelViewDelegate> delegate;
    
    NSMutableDictionary* theData;
}
@property (nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UILabel* totalProducts;
@property(nonatomic,retain) IBOutlet UILabel* totalValue;
@property(nonatomic,retain) IBOutlet UILabel* totalPoints;
@property(nonatomic,retain) IBOutlet UILabel* totalBonus;
@property(nonatomic,retain) IBOutlet UILabel* totalQty;
@property(nonatomic,retain) NSMutableDictionary* theData;


-(IBAction)donePressed:(id)sender;
@end
