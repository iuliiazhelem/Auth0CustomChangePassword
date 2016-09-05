//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

protocol LoginViewControllerDelegate {
    func changedEmail(email:String)
}

class ViewController: UIViewController, LoginViewControllerDelegate {
    
    var userId:String?
    
    required init?(coder aDecoder: NSCoder) {
        userId = nil
        super.init(coder: aDecoder)
    }


    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func clickLoginButton(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("Please eneter an email");
            return;
        }
        if (self.passwordTextField.text?.characters.count < 1) {
            self.showMessage("Please eneter a password");
            return;
        }
        
        let success = { (profile: A0UserProfile?, token: A0Token?) in
            self.userId = profile!.userId
            self.showUserProfile(profile!)
        }
        let failure = { (error: NSError) in
            self.clearUserProfile()
            print("Oops something went wrong: \(error)")
        }
        
        let email = self.emailTextField.text!;
        let password = self.passwordTextField.text!;
        let client = A0Lock.sharedLock().apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : kAuth0ConnectionType])
        
        //Login with email and password (Auth0 database connection)
        client.loginWithUsername(email, password: password, parameters: parameters, success: success, failure: failure)
    }

    func showUserProfile(profile: A0UserProfile) {
        dispatch_async(dispatch_get_main_queue()) {
            self.usernameLabel.text = profile.name
            self.emailLabel.text = profile.email
            self.userIdLabel.text = profile.userId
        }
    }

    func clearUserProfile() {
        dispatch_async(dispatch_get_main_queue()) {
            self.usernameLabel.text = ""
            self.emailLabel.text = ""
            self.userIdLabel.text = ""
        }
    }

    @IBAction func clickChangePasswordButton(sender: AnyObject) {
        //Switch to Change Password ViewController
        let controller:AKChangePasswordViewController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("AKChangePasswordViewController") as! AKChangePasswordViewController
        controller.lock = A0Lock.sharedLock()
        controller.delegate = self
        if let actualEmail = self.emailTextField.text {
            controller.email = actualEmail
        }
        
        let navController:UINavigationController = UINavigationController.init(rootViewController: controller)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
            navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        }
        self.presentViewController(navController, animated: true, completion: nil)

    }
    
    //Clear sessions
    func logout() {
        let lock = A0Lock.sharedLock()
        lock.apiClient().logout()
        lock.clearSessions()
    }
    
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Delegate method
    func changedEmail(email:String) {
        self.logout()
        self.clearUserProfile()
        self.emailTextField.text = email
    }
}
