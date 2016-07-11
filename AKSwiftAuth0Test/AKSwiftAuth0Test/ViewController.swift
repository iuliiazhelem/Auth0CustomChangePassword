//
//  ViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 08.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit
import Lock

class ViewController: UIViewController {
    
    var userId:String?
    
    required init?(coder aDecoder: NSCoder) {
        userId = nil
        super.init(coder: aDecoder)
    }


    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!

    @IBAction func clickOpenLockUIButton(sender: AnyObject) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.onAuthenticationBlock = { (profile: A0UserProfile?, token: A0Token?) in
            dispatch_async(dispatch_get_main_queue()) {
                self.usernameLabel.text = profile!.name
                self.emailLabel.text = profile!.email
                self.userIdLabel.text = profile!.userId
                self.userId = profile!.userId
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(controller, animated: true, completion: nil)

    }

    @IBAction func clickChangePasswordButton(sender: AnyObject) {
        let controller:AKChangePasswordViewController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("AKChangePasswordViewController") as! AKChangePasswordViewController
        controller.lock = A0Lock.sharedLock()
        if let actualEmail = self.emailLabel.text {
            controller.email = actualEmail
        }
        
        let navController:UINavigationController = UINavigationController.init(rootViewController: controller)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
            navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        }
        self.presentViewController(navController, animated: true, completion: nil)

    }
}

