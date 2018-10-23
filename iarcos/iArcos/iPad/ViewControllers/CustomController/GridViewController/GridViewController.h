//
//  GridViewController.h
//  Arcos
//
//  Created by David Kilmartin on 07/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewCell.h"

@interface GridViewController : UITableViewController {
    NSMutableArray* gridCells;
    NSMutableArray* gridItems;
    NSMutableArray* itemResource;
}
@property(nonatomic,retain) NSMutableArray* gridCells;
@property(nonatomic,retain) NSMutableArray* gridItems;
@property(nonatomic,retain) NSMutableArray* itemResource;
@end
