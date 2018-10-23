//
//  CustomerContactInfoTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 14/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactInfoTableCell.h"

@implementation CustomerContactInfoTableCell
@synthesize delegate;
@synthesize fullname;
@synthesize accessTimesDays = _accessTimesDays;
@synthesize contactType;
@synthesize phoneNumber;
@synthesize mobileNumber;
@synthesize contactNumber = _contactNumber;
@synthesize email;
@synthesize cellData;
@synthesize indexPath;

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

-(void)configCellWithData:(NSMutableDictionary*)theCellData {
    self.cellData = theCellData;    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.email addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    NSLog(@"email is clicked.");
    [self.delegate createEmailComposeViewController:[self.cellData objectForKey:@"Email"]];
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }        
    if (self.fullname != nil) { self.fullname = nil; }
    self.accessTimesDays = nil;
    if (self.contactType != nil) { self.contactType = nil; }            
    if (self.mobileNumber != nil) { self.mobileNumber = nil; }            
    if (self.phoneNumber != nil) { self.phoneNumber = nil; }
    self.contactNumber = nil;
    if (self.email != nil) { self.email = nil; }
    if (self.cellData != nil) { self.cellData = nil; }            
    if (self.indexPath != nil) { self.indexPath = nil; }            

    [super dealloc];
}

@end
