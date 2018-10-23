//
//  CustomerCallTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerCallTableCell : UITableViewCell {
    IBOutlet UILabel* date;
    IBOutlet UILabel* contact;
    IBOutlet UILabel* employee;
    IBOutlet UILabel* typeOfCall;
    IBOutlet UILabel* value;
    NSString* IUR;
}

@property (nonatomic,retain) IBOutlet UILabel* date;
@property (nonatomic,retain) IBOutlet UILabel* contact;
@property (nonatomic,retain) IBOutlet UILabel* employee;
@property (nonatomic,retain) IBOutlet UILabel* typeOfCall;
@property (nonatomic,retain) IBOutlet UILabel* value;
@property (nonatomic,retain) NSString* IUR;

@end
