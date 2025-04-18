//
//  CustomerStringTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerStringTableCell.h"

@implementation CustomerStringTableCell
@synthesize fieldDesc;
@synthesize contentString;

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
    if (self.fieldDesc != nil) {
        self.fieldDesc = nil;
    }
    if (self.contentString != nil) {
        self.contentString = nil;
    }
    [super dealloc];
}

-(IBAction)textInputEnd:(id)sender {
    UITextField* tf = (UITextField*)sender;
    [self.delegate inputFinishedWithData:tf.text actualData:tf.text forIndexpath:self.indexPath];
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.redAsterixLabel.hidden = YES;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    
    self.contentString.text = [theData objectForKey:@"contentString"];
    
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
//    NSLog(@"location securityLevel: %@ %d employeeSecurityLevel: %d", securityLevel, [securityLevel intValue], self.employeeSecurityLevel);
    /*
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        if ([self.fieldDesc.text isEqualToString:@"Location Code"]) {
            self.contentString.enabled = NO;
        }
    } else {
        self.contentString.enabled = NO;
    }
    
    if (self.contentString.isEnabled) {
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.textColor = [UIColor blackColor];
    }
     */
    self.contentString.enabled = YES;
    self.contentString.textColor = [UIColor blueColor];
    self.contentString.backgroundColor = [UIColor clearColor];
    if ([securityLevel intValue] == [GlobalSharedClass shared].blockedLevel || [[theData objectForKey:@"fieldDesc"] isEqualToString:@"Location Code"]) {
        self.contentString.enabled = NO;
        if ([[self.delegate retrieveParentActionType] isEqualToString:@"create"]) {
            self.contentString.backgroundColor = [UIColor lightGrayColor];
        } else {
            self.contentString.textColor = [UIColor lightGrayColor];
        }
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].mandatoryLevel) {
        [self configRedAsterix];
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].remindLevel) {
        self.contentString.backgroundColor = [UIColor yellowColor];
    }
     
}

@end
