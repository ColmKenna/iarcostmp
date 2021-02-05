//
//  CustomerContactStringTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactStringTableCell.h"

@implementation CustomerContactStringTableCell
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
    NSString* tmpFieldDesc = [theData objectForKey:@"fieldDesc"];
    self.fieldDesc.text = tmpFieldDesc;
    self.contentString.text = [theData objectForKey:@"contentString"];
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (tmpFieldDesc != nil && ([tmpFieldDesc caseInsensitiveCompare:@"Forename"] == NSOrderedSame || [tmpFieldDesc caseInsensitiveCompare:@"Surname"] == NSOrderedSame || [tmpFieldDesc caseInsensitiveCompare:@"Initial"] == NSOrderedSame)) {
        [self.contentString setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    } else {
        [self.contentString setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    /*
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        if ([self.fieldDesc.text isEqualToString:@"IUR"]) {
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
    if ([securityLevel intValue] == [GlobalSharedClass shared].blockedLevel || [[theData objectForKey:@"fieldDesc"] isEqualToString:@"IUR"]) {
        self.contentString.enabled = NO;
        self.contentString.textColor = [UIColor lightGrayColor];
    } else if ([securityLevel intValue] == [GlobalSharedClass shared].mandatoryLevel) {
        [self configRedAsterix];
    }
}


@end
