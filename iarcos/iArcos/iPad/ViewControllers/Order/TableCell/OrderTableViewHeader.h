//
//  OrderTableViewHeader.h
//  Arcos
//
//  Created by David Kilmartin on 08/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderTableViewHeader : UIViewController {
    //header view outlet
    IBOutlet UILabel* locationName;
    IBOutlet UILabel* locationAddress;
    IBOutlet UILabel* locationPhone;
    
    NSString* name;
    NSString* address;
    NSString* phone;
}
//header view outlet
@property (nonatomic, retain) IBOutlet UILabel* locationName;
@property (nonatomic, retain) IBOutlet UILabel* locationAddress;
@property (nonatomic, retain) IBOutlet UILabel* locationPhone;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* phone;
@end
