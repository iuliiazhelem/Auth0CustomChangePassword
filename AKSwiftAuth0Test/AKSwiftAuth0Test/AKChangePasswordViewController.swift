//
//  AKChangePasswordViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

let kAuth0ConnectionType = "Username-Password-Authentication"

class AKChangePasswordViewController: UIViewController {
    var delegate:LoginViewControllerDelegate! = nil
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
            self.showMessage("Please eneter an email", dismissVC: false)
            return;
        }
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
        }
        
        let client = A0Lock.sharedLock().apiClient()
        let params = A0AuthParameters.newDefaultParams()
        params[A0ParameterConnection] = kAuth0ConnectionType; // Or your configured DB connection
        
        //You can change password ONLY for Auth0 database connections
        client.requestChangePasswordForUsername(self.emailTextField.text!,
                                                parameters: params, success: { () -> Void in
                                                    self.showMessage("We have just sent you an email.to reset your password", dismissVC: true)
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
                    self.delegate.changedEmail(self.emailTextField.text!)
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
