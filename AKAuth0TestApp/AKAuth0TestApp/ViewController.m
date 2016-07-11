//
//  ViewController.m
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 09.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import "ViewController.h"
#import <Lock/Lock.h>
#import "AKChangePasswordViewController.h"

@interface ViewController ()

@property (copy, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

- (IBAction)clickOpenLockUIButton:(id)sender;
- (IBAction)clickChangePasswordButton:(id)sender;

@end

@implementation ViewController

- (IBAction)clickOpenLockUIButton:(id)sender {
    A0LockViewController *controller = [[A0Lock sharedLock] newLockViewController];
    controller.closable = YES;
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.usernameLabel.text = profile.name;
            self.emailLabel.text = profile.email;
            self.userIdLabel.text = profile.userId;
        });
        self.userId = profile.userId;
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)clickChangePasswordButton:(id)sender {
    AKChangePasswordViewController *passwordController = (AKChangePasswordViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AKChangePasswordViewController"];
    passwordController.lock = [A0Lock sharedLock];
    passwordController.email = self.emailLabel.text;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:passwordController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navController animated:YES completion:nil];
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

@end
