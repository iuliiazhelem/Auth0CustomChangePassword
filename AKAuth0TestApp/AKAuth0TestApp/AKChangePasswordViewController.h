//
//  AKChangePasswordViewController.h
//  AKAuth0TestApp
//

#import <UIKit/UIKit.h>

@class A0Lock;

@protocol LoginViewControllerDelegate <NSObject>

- (void)changedEmail:(NSString *)email;

@end

static NSString *kAuth0ConnectionType = @"Username-Password-Authentication";

@interface AKChangePasswordViewController : UIViewController

@property (weak, nonatomic)A0Lock *lock;
@property (weak, nonatomic)id<LoginViewControllerDelegate> delegate;
@property (copy, nonatomic)NSString *email;

@end
