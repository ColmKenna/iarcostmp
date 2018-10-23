//
//  PresenterTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterTableViewCell.h"


@implementation PresenterTableViewCell
//@synthesize mainImage;
@synthesize description;
@synthesize extraDesc;
@synthesize title;
@synthesize bgImageView;
@synthesize promotionView;
@synthesize subBgImage = _subBgImage;
@synthesize dividerImage = _dividerImage;
@synthesize mainButton = _mainButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
//    if (self.mainImage != nil) { self.mainImage = nil; }
    if (self.title != nil) { self.title = nil; }
    if (self.description != nil) { self.description = nil; }
    if (self.extraDesc != nil) { self.extraDesc = nil; }
    if (self.bgImageView != nil) { self.bgImageView = nil; }
    if (self.promotionView != nil) { self.promotionView = nil; }        
    self.subBgImage = nil;
    self.dividerImage = nil;
    self.mainButton = nil;
    
    [super dealloc];
}

@end
