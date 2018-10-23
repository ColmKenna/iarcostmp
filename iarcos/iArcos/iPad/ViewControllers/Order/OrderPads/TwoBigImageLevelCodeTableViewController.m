//
//  TwoBigImageLevelCodeTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "TwoBigImageLevelCodeTableViewController.h"

@interface TwoBigImageLevelCodeTableViewController ()

@end

@implementation TwoBigImageLevelCodeTableViewController
@synthesize twoBigImageLevelCodeDataManager = _twoBigImageLevelCodeDataManager;
@synthesize formType = _formType;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize navigationTitleDelegate = _navigationTitleDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden = YES;
    self.twoBigImageLevelCodeDataManager = [[[TwoBigImageLevelCodeDataManager alloc] init] autorelease];
    self.twoBigImageLevelCodeDataManager.formType = self.formType;
}

- (void)dealloc {
    self.twoBigImageLevelCodeDataManager = nil;
    if (self.formType != nil) { self.formType = nil; }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isNotFirstLoaded) return;
    [self.twoBigImageLevelCodeDataManager getBranchLeafData];
    [self.tableView reloadData];
    self.isNotFirstLoaded = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    return [self.twoBigImageLevelCodeDataManager.descrDetailSectionDict count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    NSString* aKey = [self.twoBigImageLevelCodeDataManager.sortKeyList objectAtIndex:section];
//    NSMutableArray* aSectionArray = [self.twoBigImageLevelCodeDataManager.descrDetailSectionDict objectForKey:aKey];
//    return [aSectionArray count];
    return [self.twoBigImageLevelCodeDataManager.myDescrDetailArrayList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdTwoBigImageLevelCodeTableViewCell";
    
    TwoBigImageLevelCodeTableViewCell *cell=(TwoBigImageLevelCodeTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"TwoBigImageLevelCodeTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[TwoBigImageLevelCodeTableViewCell class]] && [[(TwoBigImageLevelCodeTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (TwoBigImageLevelCodeTableViewCell *) nibItem;
            }
            
        }
        
    }
    
    //fill the data for cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell getCellReadyToUse];
    //    [cell createPopulatedLists];
    //    [cell clearAllInfo];
//    NSString* aKey=[self.twoBigImageLevelCodeDataManager.sortKeyList objectAtIndex:indexPath.section];
//    NSMutableArray* aSectionArray = [self.twoBigImageLevelCodeDataManager.descrDetailSectionDict objectForKey:aKey];
    NSMutableArray* tmpDisplayList = [self.twoBigImageLevelCodeDataManager.myDescrDetailArrayList objectAtIndex:indexPath.row];
    //    NSMutableArray* tmpDisplayList = [self.l3SearchDataManager.descrDetailList objectAtIndex:indexPath.row];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* descrDetailDict = [tmpDisplayList objectAtIndex:i];
//        UILabel* tmpLabel = [cell.labelList objectAtIndex:i];
//        tmpLabel.text = [descrDetailDict objectForKey:@"Detail"];
        
        NSNumber* imageIur = [descrDetailDict objectForKey:@"ImageIUR"];
        UIImage* anImage = nil;
        BOOL isCompanyImage = NO;
        if ([imageIur intValue] > 0) {
            anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        }else{
            anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
            isCompanyImage = YES;
        }
        if (anImage == nil) {
            anImage = [UIImage imageNamed:@"iArcos_72.png"];
        }
        UIButton* tmpBtn = [cell.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        //[tmpBtn setImage:anImage forState:UIControlStateNormal];
        [tmpBtn setBackgroundImage:anImage forState:UIControlStateNormal];
        if (isCompanyImage) {
            tmpBtn.alpha = [GlobalSharedClass shared].imageCellAlpha;
        } else {
            tmpBtn.alpha = 1.0;
        }
    }
    return cell;
}

#pragma mark TwoBigImageLevelCodeDelegate
-(void)bigImageLevelCodeWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
    switch ([self.twoBigImageLevelCodeDataManager.formTypeId intValue]) {
        case 8:
            return;
            break;
        case 9:
            [self productGridImageFormRowsWithButton:aBtn indexPath:anIndexPath];
            break;
        default:
            break;
    }
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)productGridImageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
//    NSString* aKey = [self.twoBigImageLevelCodeDataManager.sortKeyList objectAtIndex:anIndexPath.section];
//    NSMutableArray* aSectionArray = [self.twoBigImageLevelCodeDataManager.descrDetailSectionDict objectForKey:aKey];
    NSMutableArray* tmpDisplayList = [self.twoBigImageLevelCodeDataManager.myDescrDetailArrayList objectAtIndex:anIndexPath.row];
    //    NSMutableArray* tmpDisplayList = [self.l3SearchDataManager.descrDetailList objectAtIndex:anIndexPath.row];
    NSMutableDictionary* l3DescrDetailDict = [tmpDisplayList objectAtIndex:aBtn.tag];
    //    NSLog(@"descrDetailDict DescrDetailCode is %@", [l3DescrDetailDict objectForKey:@"DescrDetailCode"]);
    NSString* l3DescrDetailCode = [l3DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l3DescrDetailDict objectForKey:@"LeafChildren"];
    BranchLeafProductGridViewController* BLPGVC = [[BranchLeafProductGridViewController alloc] initWithNibName:@"BranchLeafProductGridViewController" bundle:nil];
    BLPGVC.navigationTitleDelegate = self;
    BLPGVC.title = [NSString stringWithFormat:@"%@", [l3DescrDetailDict objectForKey:@"Detail"]];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDetail = [NSString stringWithFormat:@"%@", [l3DescrDetailDict objectForKey:@"Detail"]];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode = [NSString stringWithFormat:@"%@", l3DescrDetailCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLxCode = [NSString stringWithFormat:@"%@", self.twoBigImageLevelCodeDataManager.branchLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.leafLxCode = [NSString stringWithFormat:@"%@", self.twoBigImageLevelCodeDataManager.leafLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:l5ChildrenList];
    if ([l5ChildrenList count] == 1) {
        NSMutableDictionary* l5CellDataDict = [l5ChildrenList objectAtIndex:0];
        [BLPGVC productListSelectSmallTemplateViewItemWithData:l5CellDataDict];
        [BLPGVC.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:[l5CellDataDict objectForKey:@"Detail"]];
        BLPGVC.isLeafSmallHidden = YES;
    }
    [self.navigationController pushViewController:BLPGVC animated:YES];
    [BLPGVC release];
}

#pragma mark BranchLeafProductNavigationTitleDelegate
- (void)resetTopBranchLeafProductNavigationTitle:(NSString*)aDetail {
    [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:aDetail];
}

@end
