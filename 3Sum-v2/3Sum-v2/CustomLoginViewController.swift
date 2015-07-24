//
//  CustomLoginViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/5/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class CustomLoginViewController: UIViewController {

    var numberValidated: Bool = false
    var phoneNumber: String = ""
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
//    @IBOutlet weak var passwordField: UITextField!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberValidated = false
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        step1()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func step1() {
        numberValidated = false
        resendButton.enabled = false
        resendButton.hidden = true
        hintLabel.text = "Provide a valid 10-digit US Phone Number"
        usernameField.text = ""
        usernameField.placeholder = "e.g. 555-222-1234"
        phoneNumber = ""
    }
    
    func step2() {
        numberValidated = true
        resendButton.enabled = true
        resendButton.hidden = false
        hintLabel.text = "Enter the 4-digit confirmation code"
        usernameField.text = ""
        usernameField.placeholder = "XXXX"
    }
    func showAlert(title: String, message: String) {
        return UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("alertOK", comment: "OK")).show()
    }
    
    func doLogin(phoneNumber: String, code: Int) {
        self.editing = false
        let params = ["phoneNumber": phoneNumber, "codeEntry": code] as [NSObject:AnyObject]
        PFCloud.callFunctionInBackground("logIn", withParameters: params) {
            (response: AnyObject?, error: NSError?) -> Void in
            if let description = error?.description {
                self.editing = true
                return self.showAlert("Login Error", message: description)
            }
            if let token = response as? String {
                PFUser.becomeInBackground(token) { (user: PFUser?, error: NSError?) -> Void in
                    if let error = error {
                        self.showAlert("Login Error", message: NSLocalizedString("warningGeneral", comment: "Something happened while trying to log in.\nPlease try again."))
                        self.editing = true
                        return self.step1()
                    }
                    self.updateUserRegistration()
                    
                    // capturing/validating additional user information
                    println("Gathering User Info")
                    self.performSegueWithIdentifier("signup", sender: self)
                    
                    //self.navigationController?.popToRootViewControllerAnimated(true)
                    //return self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                self.editing = true
                self.showAlert("Login Error", message: NSLocalizedString("warningGeneral", comment: "Something went wrong.  Please try again."))
                return self.step1()
            }
        }
    }

    
    @IBAction func sendLoginCode() {
        
            self.editing = false
            let params = ["phoneNumber" : phoneNumber, "language" : "en"]
            PFCloud.callFunctionInBackground("sendCode", withParameters: params) {
                (response: AnyObject?, error: NSError?) -> Void in
                self.editing = true
                if let error = error {
                    var description = error.description
                    if count(description) == 0 {
                        description = NSLocalizedString("warningGeneral", comment: "Something went wrong.  Please try again.") // "There was a problem with the service.\nTry again later."
                    } else if let message = error.userInfo?["error"] as? String {
                        description = message
                    }
                    
                    self.showAlert("Login Error", message: description)
                    return self.step1()
                }
                return self.step2()
        }
    }


    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
//        var password = self.passwordField.text
   
        if (self.numberValidated == false) {
            // user provided phone number
            if ((count(username.utf16) > 0 && (count(username.utf16) < 10  || !username.isPhone)) )
            {
                var alert = UIAlertView(title: "Invalid", message: "Provide a valida 10-digit US phone number ", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                step1()
            } else {
                phoneNumber = usernameField.text
                //todo
                //println("Gathering User Info")
                //self.performSegueWithIdentifier("signup", sender: self)

                sendLoginCode()
                return self.step2()
            }
        } else {
            println("performing login")
            if let code = username.toInt() {
                if count(username) == 4 {
                    return doLogin(phoneNumber, code: code)
                }
            }
        }
    
        self.showAlert("You must enter 4 digit code ", message: description)

        step2()
        
/*
        if ((count(username.utf16) > 0 && (count(username.utf16) < 10  || !username.isPhone)) ||
        count(password.utf16) < 5)
        {
            var alert = UIAlertView(title: "Invalid", message: "Username must be valid phone number and Password must be longer than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((user) != nil) {
                    var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK")
                    println("user logged in")
                    self.updateUserRegistration()
                    //alert.show()
                } else {
                    var alert = UIAlertView(title: "failed", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                
            })
            
            updateUserRegistration()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
     */
        
    }

    
    @IBAction func resendCode(sender: AnyObject) {
        println("Resend Code")
        sendLoginCode()
       // step2()
    }
    

    
    
    func updateUserRegistration() {
        let currentInstallation = PFInstallation.currentInstallation()
        
        NSLog("registering installation for user: \(PFUser.currentUser()?.username)")
       
        if (PFUser.currentUser()?.username != nil) {
            currentInstallation["user"] = PFUser.currentUser()?.username
        }
        
        currentInstallation.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                NSLog("registered channels for user: \(PFUser.currentUser()?.username)")
            } else {
                NSLog("%@", error!)
            }
            
        }
    }

    
}
