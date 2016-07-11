//
//  AKChangePasswordViewController.m
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 11.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import "AKChangePasswordViewController.h"
#import <Lock/Lock.h>

static NSString *kAuth0ConnectionType = @"Username-Password-Authentication";

@interface AKChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)clickChangePasswordButton:(id)sender;
- (IBAction)clickCancelButton:(id)sender;

@end

@implementation AKChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.email.length > 0) {
        self.emailTextField.text = self.email;
    }
}

- (IBAction)clickChangePasswordButton:(id)sender {
    if (self.emailTextField.text.length < 1) {
        [self showMessage:@"You need to eneter email" dismissVC:NO];
        return;
    }
    
    A0APIClient *client = [self.lock apiClient];
    A0AuthParameters *params = [A0AuthParameters newDefaultParams];
    params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
    
    [client requestChangePasswordForUsername:self.emailTextField.text
                                  parameters:params
                                     success:^{
                                         NSLog(@"Please check your email!");
                                         [self showMessage:@"Please check your email!" dismissVC:YES];
                                         
                                     } failure:^(NSError * _Nonnull error) {
                                         [self showMessage:[NSString stringWithFormat:@"%@", error] dismissVC:NO];
                                     }];
}

- (IBAction)clickCancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showMessage:(NSString *)message dismissVC:(BOOL)dismissVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Auth0" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (dismissVC){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                });
            }
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
