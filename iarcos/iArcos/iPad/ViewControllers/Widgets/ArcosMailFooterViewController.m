//
//  ArcosMailFooterViewController.m
//  iArcos
//
//  Created by Richard on 13/09/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ArcosMailFooterViewController.h"
#import "ArcosCoreData.h"

@interface ArcosMailFooterViewController ()

@end

@implementation ArcosMailFooterViewController
@synthesize templateView = _templateView;
@synthesize myImageView = _myImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* tmpImageIUR = [employeeDict objectForKey:@"ImageIUR"];
    UIImage* tmpSignatureImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:tmpImageIUR];
    self.myImageView.image = tmpSignatureImage;
}

- (void)dealloc {
    self.templateView = nil;
    self.myImageView = nil;
    
    [super dealloc];
}



@end
