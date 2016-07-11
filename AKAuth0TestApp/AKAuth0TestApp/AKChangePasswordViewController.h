//
//  AKChangePasswordViewController.h
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 11.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class A0Lock;

@interface AKChangePasswordViewController : UIViewController

@property (weak, nonatomic)A0Lock *lock;
@property (copy, nonatomic)NSString *email;
@end
