//
//  MapPopoverViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressAnnotation.h"
#import "StockistParentTableViewController.h"
@protocol MapPopoverDelegate 

@optional
- (void)removePin:(AddressAnnotation*)anno;
- (void)searchRadius:(NSInteger)radius AroundMe:(AddressAnnotation*)anno;
- (void)detailTouched:(AddressAnnotation*)anno;
- (void)stockistPressed:(AddressAnnotation*)anno;
- (void)didSelectStockistChildWithCellData:(NSDictionary *)aCellData annotation:(AddressAnnotation*)anno radius:(int)aRadiusValue;
@end

@interface MapPopoverViewController : UIViewController{
    id <MapPopoverDelegate> delegate;
    AddressAnnotation* annotation;
    IBOutlet UIButton* aroundMe;
    IBOutlet UIButton* removePin;
    IBOutlet UILabel* radiusLabel;
    IBOutlet UISlider* radiusSlider;
    NSInteger radiusValue;
    id<StockistChildTableViewDelegate> _childDelegate;
}
@property(nonatomic,assign)AddressAnnotation* annotaion;
@property(nonatomic,retain)id <MapPopoverDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIButton* aroundMe;
@property(nonatomic,retain) IBOutlet UIButton* removePin;
@property(nonatomic,retain) IBOutlet UILabel* radiusLabel;
@property(nonatomic,retain) IBOutlet UISlider* radiusSlider;
@property(nonatomic,assign) id<StockistChildTableViewDelegate> childDelegate;


-(IBAction)lookAround:(id)sender;
-(IBAction)removePin:(id)sender;
-(IBAction)radiusChange:(id)sender;
-(IBAction)detailTouched:(id)sender;
-(IBAction)stockistPressed:(id)sender;
@end
