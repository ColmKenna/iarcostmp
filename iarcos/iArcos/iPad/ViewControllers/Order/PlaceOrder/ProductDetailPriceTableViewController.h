//
//  ProductDetailPriceTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailDataManager.h"
//#import "ProductDetailStockTableCell.h"
#import "ArcosGenericHeaderViewController.h"
#import "ProductDetailPriceTableCell.h"

@interface ProductDetailPriceTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    ProductDetailDataManager* _productDetailDataManager;
    ArcosGenericHeaderViewController* _arcosGenericHeaderViewController;
}

@property(nonatomic, retain) ProductDetailDataManager* productDetailDataManager;
@property(nonatomic, retain) ArcosGenericHeaderViewController* arcosGenericHeaderViewController;

@end
