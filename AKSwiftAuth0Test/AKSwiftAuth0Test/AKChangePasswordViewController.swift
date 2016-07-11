//
//  AKChangePasswordViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 11.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit
import Lock

let kAuth0ConnectionType = "Username-Password-Authentication"

class AKChangePasswordViewController: UIViewController {
    var email:String?
    var lock: A0Lock!

    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let actualEmail = self.email {
            emailTextField.text = actualEmail
        }
    }
    
    @IBAction func clickChangePasswordButton(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("You need to eneter email", dismissVC: false)
            return;
        }
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
        }
        
        let client = A0Lock.sharedLock().apiClient()
        let params = A0AuthParameters.newDefaultParams()
        params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
        
        client.requestChangePasswordForUsername(self.emailTextField.text!,
                                                parameters: params, success: { () -> Void in
                                                    print("success reset passwd")
                                                    self.showMessage("Awesome! Please Check your email.", dismissVC: true)
            }, failure: failure)

    }
    
    @IBAction func clickCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func showMessage(message: String, dismissVC:ObjCBool) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) -> Void in
                if dismissVC {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
