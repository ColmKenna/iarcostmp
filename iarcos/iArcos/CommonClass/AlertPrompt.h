
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertPrompt : NSObject
{
//	UITextField	*textField;
}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
//- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
