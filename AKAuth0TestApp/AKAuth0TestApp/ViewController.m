//
//  ViewController.m
//  AKAuth0TestApp
//

#import "ViewController.h"
#import <Lock/Lock.h>
#import "AKChangePasswordViewController.h"

@interface ViewController ()<LoginViewControllerDelegate>

@property (copy, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)clickLoginButton:(id)sender;
- (IBAction)clickChangePasswordButton:(id)sender;

@end

@implementation ViewController

- (IBAction)clickLoginButton:(id)sender {
    if (self.emailTextField.text.length < 1) {
        [self showMessage:@"Please eneter an email"];
        return;
    }
    if (self.passwordTextField.text.length < 1) {
        [self showMessage:@"Please eneter a password"];
        return;
    }
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    A0APIClient *client = [[A0Lock sharedLock] apiClient];
    A0APIClientAuthenticationSuccess success = ^(A0UserProfile *profile, A0Token *token) {
        [self showUserProfile:profile];
        self.userId = profile.userId;
    };
    A0APIClientError error = ^(NSError *error){
        NSLog(@"Oops something went wrong: %@", error);
        [self clearUserProfile];
    };
    
    A0AuthParameters *params = [A0AuthParameters newDefaultParams];
    params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
    
    //Login with email and password (Auth0 database connection)
    [client loginWithUsername:email
                     password:password
                   parameters:params
                      success:success
                      failure:error];
}

- (IBAction)clickChangePasswordButton:(id)sender {
    //Switch to Change Password ViewController
    AKChangePasswordViewController *passwordController = (AKChangePasswordViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AKChangePasswordViewController"];
    passwordController.lock = [A0Lock sharedLock];
    passwordController.delegate = self;
    passwordController.email = self.emailTextField.text;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:passwordController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navController animated:YES completion:nil];
}

//Clear sessions
- (void)logout {
    A0Lock *lock = [A0Lock sharedLock];
    [[lock apiClient] logout];
    [lock clearSessions];
}

- (void)showUserProfile:(A0UserProfile *)profile {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.usernameLabel.text = profile.name;
        self.emailLabel.text = profile.email;
        self.userIdLabel.text = profile.userId;
    });
}

- (void)clearUserProfile {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.usernameLabel.text = @"";
        self.emailLabel.text = @"";
        self.userIdLabel.text = @"";
    });
}

- (void)showMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Auth0" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

//Delegate method
- (void)changedEmail: (NSString *)email {
    [self logout];
    [self clearUserProfile];
    self.emailTextField.text = email;
}

@end
