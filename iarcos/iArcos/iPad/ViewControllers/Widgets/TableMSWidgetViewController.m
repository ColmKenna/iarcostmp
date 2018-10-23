//
//  TableMSWidgetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 30/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "TableMSWidgetViewController.h"

@interface TableMSWidgetViewController ()

@end

@implementation TableMSWidgetViewController
@synthesize delegate = _delegate;
@synthesize tableMSWidgetRequestSource = _tableMSWidgetRequestSource;
@synthesize myTableView = _myTableView;
@synthesize myNavigationBar = _myNavigationBar;
@synthesize myNavBarTitle = _myNavBarTitle;
@synthesize displayList = _displayList;
@synthesize parentItemList = _parentItemList;

- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList requestSource:(TableMSWidgetRequestSource)aTableMSWidgetRequestSource {
    [self initWithNibName:@"TableMSWidgetViewController" bundle:nil];
    self.displayList = aDataList;
    self.myNavBarTitle = aTitle;
    self.parentItemList = aParentItemList;
    self.tableMSWidgetRequestSource = aTableMSWidgetRequestSource;
    if (self.displayList == nil || [self.displayList count] <= 0) {
        anyDataSource = NO;
    }else{
        anyDataSource = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.myNavigationBar.topItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];
    [self.myNavigationBar.topItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.myNavigationBar.topItem.title = self.myNavBarTitle;
}

- (void)dealloc {
    self.myTableView = nil;
    self.myNavigationBar = nil;
    self.myNavBarTitle = nil;
    self.displayList = nil;
    self.parentItemList = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)cancelPressed {
    [self.delegate dismissPopoverController];
}

- (void)savePressed {
    NSMutableArray* resultList = [NSMutableArray array];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpCellData = [self.displayList objectAtIndex:i];
        NSNumber* selectedNumber = [tmpCellData objectForKey:@"IsSelected"];
        if ([selectedNumber boolValue]) {
            [resultList addObject:[tmpCellData objectForKey:@"Title"]];
            if (i == 0) break;
        }
    }
    NSString* resultString = [resultList componentsJoinedByString:@"|"];
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:1];
    [cellData setObject:resultString forKey:@"Title"];
    [self.delegate operationDone:cellData];
//    NSLog(@"resultString: %@", resultString);
    [self.delegate dismissPopoverController];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.displayList != nil) {
        return [self.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdGenericGroupedImageTableCell";
    
    GenericGroupedImageTableCell *cell=(GenericGroupedImageTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericGroupedImageTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericGroupedImageTableCell class]] && [[(GenericGroupedImageTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (GenericGroupedImageTableCell *) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellDict = [self.displayList objectAtIndex:indexPath.row];
    cell.myTextLabel.text = [cellDict objectForKey:@"Title"];
    
    if ([self.parentItemList containsObject:cell.myTextLabel.text]) {
//        self.currentIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cellDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cellDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    }
    
    if ([cellDict objectForKey:@"Active"] != nil &&
        [[cellDict objectForKey:@"Active"] intValue] == 0) {
        cell.myTextLabel.textColor = [UIColor redColor];
    } else {
        cell.myTextLabel.textColor = [UIColor blackColor];
    }
    NSNumber* imageIur = [cellDict objectForKey:@"ImageIUR"];
    if (imageIur != nil) {
        UIImage* anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        if (anImage == nil) {
            anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
        }
        cell.myImageView.image = anImage;
    } else {
        cell.myImageView.image = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [cell configImageView];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GenericGroupedImageTableCell* cell = (GenericGroupedImageTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    NSNumber* selectedNumber = [cellData objectForKey:@"IsSelected"];
    if ([selectedNumber boolValue]) {
        [self.parentItemList removeObject:cell.myTextLabel.text];
        [cellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    } else {
        if ([[cellData objectForKey:@"Title"] isEqualToString:[GlobalSharedClass shared].unknownText]) {
            [self.parentItemList removeAllObjects];
            for (int i = 0; i < [self.displayList count]; i++) {
                NSMutableDictionary* tmpCellData = [self.displayList objectAtIndex:i];
                [tmpCellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
            }
        } else {
            [self.parentItemList removeObject:[GlobalSharedClass shared].unknownText];
            NSMutableDictionary* tmpCellData = [self.displayList objectAtIndex:0];
            [tmpCellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        }
        [self.parentItemList addObject:cell.myTextLabel.text];
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    }
    [self.myTableView reloadData];
}


@end
