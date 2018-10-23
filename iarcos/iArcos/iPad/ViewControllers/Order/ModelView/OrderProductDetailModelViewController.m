//
//  OrderProductDetailModelViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderProductDetailModelViewController.h"
#import "GlobalSharedClass.h"

@implementation OrderProductDetailModelViewController
@synthesize  name;
@synthesize  price;
@synthesize  value;
@synthesize  qty;
@synthesize  discount;
@synthesize  bonus;
@synthesize  point;

@synthesize  qtyInput;
@synthesize  discountInput;
@synthesize  bonusInput;
@synthesize  pointInput;

@synthesize  save;
@synthesize  dismiss;

@synthesize isViewEditable;
@synthesize theData;

@synthesize delegate;

@synthesize pickerParentView;
@synthesize picker;
@synthesize pickerData;
@synthesize showPickerBut;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isViewEditable=NO;
    }
    return self;
}

- (void)dealloc
{
    [  name release];
    [  price release];
    [  value release];
    [  qty release];
    [  discount release];
    [  bonus release];
    [  point release];
    
    [  qtyInput release];
    [  discountInput release];
    [  bonusInput release];
    [  pointInput release];
    
    [  save release];
    [  dismiss release];
    
    [pickerParentView release];
    [picker release];
    [showPickerBut release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)refreshViewContent{
    //line value
    NSNumber* theQty=[self.theData objectForKey:@"Qty"];
    NSNumber* unitPrice=[self.theData objectForKey:@"UnitPrice"];
    NSNumber* lineValue=[NSNumber numberWithFloat: [unitPrice floatValue]*[theQty intValue]];
    [self.theData setObject:lineValue forKey:@"LineValue"];
    
    //fill data
    name.text=[self.theData objectForKey:@"Description"];
    price.text=[[self.theData objectForKey:@"UnitPrice"]stringValue];
    value.text=[[self.theData objectForKey:@"LineValue"]stringValue];
    qty.text=[[self.theData objectForKey:@"Qty"]stringValue];
    discount.text=[[self.theData objectForKey:@"DiscountPercent"]stringValue];
    bonus.text=[[self.theData objectForKey:@"Bonus"]stringValue];
    point.text=[[self.theData objectForKey:@"point"]stringValue];
    
    qtyInput.text=[[self.theData objectForKey:@"Qty"]stringValue];
    discountInput.text=[[self.theData objectForKey:@"DiscountPercent"]stringValue];
    bonusInput.text=[[self.theData objectForKey:@"Bonus"]stringValue];
    pointInput.text=[[self.theData objectForKey:@"point"]stringValue];
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];
    [self showEditInput:self.isViewEditable];
    
    [self refreshViewContent];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pickerData=[NSMutableDictionary dictionary];
    NSMutableArray* QTYArray=[NSMutableArray array];
    NSMutableArray* discountArray=[NSMutableArray array];
    NSMutableArray* bonusArray=[NSMutableArray array];
    
    for (int i=1; i<=100 ;  i++) {
        [QTYArray addObject:[NSNumber numberWithInt:i]];
        [discountArray addObject:[NSNumber numberWithFloat:i]];
        [bonusArray addObject:[NSNumber numberWithFloat:i]];
    }
    
    [discountArray insertObject:[NSNumber numberWithFloat:0] atIndex:0];
    [bonusArray insertObject:[NSNumber numberWithFloat:0] atIndex:0];
    
    //picker
    [pickerData setObject:QTYArray forKey:@"QTY"];
    [pickerData setObject:discountArray forKey:@"Discount"];
    [pickerData setObject:bonusArray forKey:@"Bonus"];    
    needPicker=NO;
    [self needShowPicker:needPicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
//functions
-(void)showEditInput:(BOOL)show{
    if (show) {
        qtyInput.hidden=NO;
        bonusInput.hidden=NO;
        //pointInput.hidden=NO;
        discountInput.hidden=NO;
        save.hidden=NO;
        showPickerBut.hidden=NO;

        [dismiss setTitle:@"Cancel" forState:UIControlStateNormal];
        
        qty.hidden=YES;
        bonus.hidden=YES;
        //point.hidden=YES;
        discount.hidden=YES;
        

    }else{
        qtyInput.hidden=YES;
        bonusInput.hidden=YES;
        //pointInput.hidden=YES;
        discountInput.hidden=YES;
        save.hidden=YES;
        showPickerBut.hidden=YES;

        [dismiss setTitle:@"Cancel" forState:UIControlStateNormal];

        qty.hidden=NO;
        bonus.hidden=NO;
        //point.hidden=NO;
        discount.hidden=NO;
        
    }
}

-(BOOL)saveLineData{
    if (![[GlobalSharedClass shared]isNumeric:qtyInput.text]) {
        [self.theData setObject:[NSNumber numberWithInt:0] forKey:@"Qty"];
    }else{
        [self.theData setObject:[NSNumber numberWithInt:[qtyInput.text intValue]] forKey:@"Qty"];

    }

    
    if (![[GlobalSharedClass shared]isNumeric:discountInput.text]) {
        [self.theData setObject:[NSNumber numberWithFloat:0] forKey:@"DiscountPercent"];
    }else{
        [self.theData setObject:[NSNumber numberWithFloat:[discountInput.text floatValue]] forKey:@"DiscountPercent"];

    }
    
    
    if (![[GlobalSharedClass shared]isNumeric:bonusInput.text]) {    
        [self.theData setObject:[NSNumber numberWithFloat:0] forKey:@"Bonus"];
    }else{
        [self.theData setObject:[NSNumber numberWithFloat:[bonusInput.text floatValue]] forKey:@"Bonus"];
    }
    
    if (([qtyInput.text intValue]<=0 || qtyInput.text ==nil) && ([bonusInput.text intValue]<=0 || bonusInput.text==nil)){

        [self.theData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    }else{
        [self.theData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];

    }
    
    return YES;
}
//actions
-(void)needShowPicker:(BOOL)need{
    if (!need) {
//         pickerParentView.frame=CGRectMake(picker.frame.origin.x, picker.frame.origin.y+300, picker.frame.size.width, picker.frame.size.height);
        pickerParentView.hidden=YES;
    }else{
//        pickerParentView.frame=CGRectMake(picker.frame.origin.x, picker.frame.origin.y-300, picker.frame.size.width, picker.frame.size.height);
        pickerParentView.hidden=NO;

    }
   
}
-(IBAction)pickADate:(id)sender{
    
}
-(IBAction)saveLine:(id)sender{
    //need save to the saved order table
    if ([self saveLineData]) {
        [self.delegate savePressedWithNewData:self.theData];
        [self.delegate didDismissModalView];
    }else{
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Error" 
                                                        message:@"Please give a valid value!" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];	
        [alert release];
    }
    
}
-(IBAction)dismissView:(id)sender{
    [self.delegate didDismissModalView];
}
-(IBAction)showPicker:(id)sender{
    needPicker=!needPicker;
    [self needShowPicker:needPicker];
}
#pragma mark picker delegate
- (NSMutableArray*)arrayOfComponent:(NSInteger)component{
    NSMutableArray* array=nil;
    switch (component) {
        case 0:
            array=[self.pickerData objectForKey:@"QTY"];
            break;
        case 1:
            array=[self.pickerData objectForKey:@"Discount"];
            break;
        case 2:
            array=[self.pickerData objectForKey:@"Bonus"];
            break;
            
        default:
            break;
    }
    return array;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.pickerData count];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    
    return [[self arrayOfComponent:component]count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableArray* array=[self arrayOfComponent:component];
    NSString* aTitle=[[array objectAtIndex:row]stringValue];
    return aTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSLog(@"select the row %d in componet %d",row,component);
    NSMutableArray* array=[self arrayOfComponent:component];
    NSNumber* selectedNumber=[array objectAtIndex:row];
    
    switch (component) {
        case 0:
            [self.theData setObject:selectedNumber forKey:@"Qty"];
            break;
        case 1:
            [self.theData setObject:selectedNumber forKey:@"DiscountPercent"];
            break;
        case 2:
            [self.theData setObject:selectedNumber forKey:@"Bonus"];
            break;
            
        default:
            break;
    }
    
    [self refreshViewContent];
}
@end
