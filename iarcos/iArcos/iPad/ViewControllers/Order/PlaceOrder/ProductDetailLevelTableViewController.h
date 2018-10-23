//
//  ProductDetailLevelTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailDataManager.h"
#import "ProductDetailLevelTableCell.h"
#import "ArcosGenericHeaderViewController.h"

@interface ProductDetailLevelTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    ProductDetailDataManager* _productDetailDataManager;
    ArcosGenericHeaderViewController* _arcosGenericHeaderViewController;
}

@property(nonatomic, retain) ProductDetailDataManager* productDetailDataManager;
@property(nonatomic, retain) ArcosGenericHeaderViewController* arcosGenericHeaderViewController;

@end
