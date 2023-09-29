

#import "AlertPrompt.h"


@implementation AlertPrompt
@synthesize textField;
@synthesize enteredText;
/*
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil];
	if (self!=nil)
	{
        
		//CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
		//[self setTransform:translate];
        self.alertViewStyle = UIAlertViewStyleSecureTextInput;
	}
	return self;
}

- (void)show
{
//	[textField becomeFirstResponder];
    [[self textFieldAtIndex:0] becomeFirstResponder];
	[super show];
}
- (NSString *)enteredText
{
//	return textField.text;
    return [self textFieldAtIndex:0].text;
}
 */
- (void)dealloc
{
//	[textField release];
	[super dealloc];
}
@end
